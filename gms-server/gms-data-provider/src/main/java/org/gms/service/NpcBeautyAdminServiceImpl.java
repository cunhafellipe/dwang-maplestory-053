package org.gms.service;

import com.mybatisflex.core.query.QueryWrapper;
import lombok.extern.slf4j.Slf4j;
import org.gms.constants.npc.NpcFunc;
import org.gms.dao.entity.NpcBeautyCatDO;
import org.gms.dao.entity.NpcBeautyMappingDO;
import org.gms.dao.entity.NpcBeautyPoolDO;
import org.gms.dao.entity.NpcBeautyPoolItemDO;
import org.gms.dao.entity.NpcDialog;
import org.gms.dao.entity.NpcFuncListDO;
import org.gms.dao.mapper.NpcBeautyCatMapper;
import org.gms.dao.mapper.NpcBeautyMappingMapper;
import org.gms.dao.mapper.NpcBeautyPoolItemMapper;
import org.gms.dao.mapper.NpcBeautyPoolMapper;
import org.gms.dao.mapper.NpcDialogMapper;
import org.gms.model.dto.BeautyMappingDTO;
import org.gms.model.dto.BeautyPoolDTO;
import org.gms.model.dto.BeautyPoolItemBatchDTO;
import org.gms.model.dto.BeautyPoolItemDTO;
import org.gms.model.dto.BeautyPoolRefDTO;
import org.gms.model.dto.BeautySearchRtnDTO;
import org.gms.model.dto.BeautyStyleBatchAddDTO;
import org.gms.model.dto.BeautyStyleOverviewDTO;
import org.gms.model.dto.BeautyWzStyleDTO;
import org.gms.model.dto.NpcBeautyDetailDTO;
import org.gms.property.ServiceProperty;
import org.gms.provider.wz.WzFiles;
import org.gms.server.StringInfoProvider;
import org.gms.util.RequireUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.TreeMap;
import java.util.stream.Collectors;

import static org.gms.dao.entity.table.NpcBeautyCatDOTableDef.NPC_BEAUTY_CAT_D_O;
import static org.gms.dao.entity.table.NpcBeautyMappingDOTableDef.NPC_BEAUTY_MAPPING_D_O;
import static org.gms.dao.entity.table.NpcBeautyPoolDOTableDef.NPC_BEAUTY_POOL_D_O;
import static org.gms.dao.entity.table.NpcBeautyPoolItemDOTableDef.NPC_BEAUTY_POOL_ITEM_D_O;
import static org.gms.dao.entity.table.NpcDialogTableDef.NPC_DIALOG;

/**
 * NPC 美容/美发 管理后台服务实现类 (基于 MyBatis-Flex)
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/13
 */
@Slf4j
@Service
public class NpcBeautyAdminServiceImpl implements NpcBeautyAdminService {

    /** 发型类型 */
    private static final String TYPE_HAIR = "HAIR";
    /** 脸型类型 */
    private static final String TYPE_FACE = "FACE";
    /** Character.wz 下的发型目录 */
    private static final String WZ_HAIR_DIR = "Hair";
    /** Character.wz 下的脸型目录 */
    private static final String WZ_FACE_DIR = "Face";
    /** WZ 导出的 XML 后缀 */
    private static final String IMG_XML_SUFFIX = ".img.xml";
    /** WZ 导出的 XML 通配 */
    private static final String IMG_XML_PATTERN = "*.img.xml";
    /** 美容台词类型 */
    private static final String DEFAULT_DIALOG_TYPE = "beauty";
    /** 美容台词模板 ID */
    private static final int DEFAULT_TEMPLATE_ID = 2;
    /** 发型可选颜色数量 (同款发型 styleId + 0 ~ +7) */
    private static final int HAIR_COLOR_COUNT = 8;
    /** 脸型可选眼睛颜色数量 (同款脸型 styleId + 0 / +100 ... +700) */
    private static final int FACE_COLOR_COUNT = 8;
    /** 发型性别区间: {起始ID, 结束ID, 性别} */
    private static final int[][] HAIR_GENDER_RANGES = {
            {30000, 30999, 0},
            {31000, 31999, 1}
    };
    /** 脸型性别区间: {起始ID, 结束ID, 性别} */
    private static final int[][] FACE_GENDER_RANGES = {
            {20000, 20999, 0},
            {21000, 21999, 1}
    };

    @Autowired
    private NpcBeautyCatMapper catMapper;
    @Autowired
    private NpcBeautyPoolMapper poolMapper;
    @Autowired
    private NpcBeautyPoolItemMapper poolItemMapper;
    @Autowired
    private NpcBeautyMappingMapper mappingMapper;
    @Autowired
    private NpcDialogMapper dialogMapper;
    @Autowired
    private NpcFuncService npcFuncService;
    @Autowired
    private ServiceProperty serviceProperty;

    // =========================================================================
    // 查询
    // =========================================================================

    @Override
    public List<BeautySearchRtnDTO> getBeautyList() {
        // 1. 统计每个 NPC 已绑定的美容池数量
        Map<Integer, Integer> poolCountMap = new HashMap<>();
        List<NpcBeautyMappingDO> allMappings = mappingMapper.selectListByQuery(
                QueryWrapper.create().from(NPC_BEAUTY_MAPPING_D_O));
        for (NpcBeautyMappingDO mapping : allMappings) {
            if (mapping.getNpcId() == null || mapping.getNpcId() <= 0) {
                continue;
            }
            poolCountMap.merge(mapping.getNpcId(), 1, Integer::sum);
        }

        // 2. npc_function_list 中登记了 BEAUTY 业务的 NPC
        Map<Integer, Integer> funcIdMap = new LinkedHashMap<>();
        for (NpcFuncListDO row : npcFuncService.selectByType(NpcFunc.BEAUTY.name())) {
            if (row.getNpcId() == null || row.getNpcId() <= 0) {
                continue;
            }
            funcIdMap.putIfAbsent(row.getNpcId(), row.getId());
        }

        // 3. 绑定表里存在但未登记 BEAUTY 业务的 NPC 也一并展示, 避免导入数据后无法在后台维护
        List<Integer> orderedNpcIds = new ArrayList<>(funcIdMap.keySet());
        poolCountMap.keySet().stream()
                .filter(npcId -> !funcIdMap.containsKey(npcId))
                .sorted()
                .forEach(orderedNpcIds::add);

        List<BeautySearchRtnDTO> result = new ArrayList<>();
        for (Integer npcId : orderedNpcIds) {
            result.add(BeautySearchRtnDTO.builder()
                    .funcId(funcIdMap.get(npcId))
                    .npcId(npcId)
                    .npcName(resolveNpcName(npcId))
                    .mapName(StringInfoProvider.getNpcExistMapName(npcId))
                    .poolCount(poolCountMap.getOrDefault(npcId, 0))
                    .registered(funcIdMap.containsKey(npcId))
                    .build());
        }
        return result;
    }

    @Override
    public NpcBeautyDetailDTO getNpcBeautyDetail(int npcId) {
        NpcFuncListDO func = npcFuncService.selectByNpcIdAndType(npcId, NpcFunc.BEAUTY.name());
        return NpcBeautyDetailDTO.builder()
                .funcId(func == null ? null : func.getId())
                .npcId(npcId)
                .npcName(resolveNpcName(npcId))
                .mapName(StringInfoProvider.getNpcExistMapName(npcId))
                .categories(getCategoryList())
                .pools(getPoolList())
                .mappings(getMappingList(npcId))
                .dialogs(loadDialogList(npcId, DEFAULT_DIALOG_TYPE))
                .build();
    }

    @Override
    public List<NpcBeautyCatDO> getCategoryList() {
        return catMapper.selectListByQuery(QueryWrapper.create()
                .from(NPC_BEAUTY_CAT_D_O)
                .orderBy(NPC_BEAUTY_CAT_D_O.MENU_INDEX.asc(), NPC_BEAUTY_CAT_D_O.ID.asc()));
    }

    @Override
    public List<BeautyPoolDTO> getPoolList() {
        Map<Integer, NpcBeautyCatDO> catMap = loadCategoryMap();
        Map<Integer, Long> itemCountMap = loadPoolItemCountMap();
        List<NpcBeautyPoolDO> pools = poolMapper.selectListByQuery(QueryWrapper.create()
                .from(NPC_BEAUTY_POOL_D_O)
                .orderBy(NPC_BEAUTY_POOL_D_O.ID.asc()));

        List<BeautyPoolDTO> result = new ArrayList<>();
        for (NpcBeautyPoolDO pool : pools) {
            result.add(toPoolDTO(pool, catMap.get(pool.getCategoryId()),
                    itemCountMap.getOrDefault(pool.getId(), 0L)));
        }
        return result;
    }

    @Override
    public List<BeautyPoolItemDTO> getPoolItemList(Integer poolId) {
        RequireUtil.requireNotNull(poolId, "资源池ID不能为空");
        List<Integer> poolIds = Collections.singletonList(poolId);
        return loadPoolItemDTOList(poolIds, loadPoolBeautyTypeMap(poolIds))
                .getOrDefault(poolId, Collections.emptyList());
    }

    @Override
    public List<BeautyStyleOverviewDTO> getStyleOverview(String beautyType, Integer gender) {
        String type = normalizeBeautyType(beautyType);
        // 皮肤等类型没有 Character.wz 样式表
        if (!TYPE_HAIR.equals(type) && !TYPE_FACE.equals(type)) {
            return Collections.emptyList();
        }

        // 1. 统计每个样式被哪些资源池引用 (按分类过滤: 发型样式只在发型池里统计)
        Map<Integer, NpcBeautyCatDO> catMap = loadCategoryMap();
        Map<Integer, NpcBeautyPoolDO> poolMap = poolMapper.selectListByQuery(
                        QueryWrapper.create().from(NPC_BEAUTY_POOL_D_O)).stream()
                .filter(pool -> pool.getId() != null)
                .collect(Collectors.toMap(NpcBeautyPoolDO::getId, pool -> pool, (a, b) -> a));

        Map<Integer, List<BeautyPoolRefDTO>> refMap = new HashMap<>();
        for (NpcBeautyPoolItemDO item : poolItemMapper.selectListByQuery(
                QueryWrapper.create().from(NPC_BEAUTY_POOL_ITEM_D_O))) {
            if (item.getPoolId() == null || item.getStyleId() == null) {
                continue;
            }
            NpcBeautyPoolDO pool = poolMap.get(item.getPoolId());
            if (pool == null) {
                continue;
            }
            NpcBeautyCatDO cat = catMap.get(pool.getCategoryId());
            if (cat == null || !type.equalsIgnoreCase(cat.getBeautyType())) {
                continue;
            }
            refMap.computeIfAbsent(item.getStyleId(), key -> new ArrayList<>())
                    .add(BeautyPoolRefDTO.builder()
                            .poolId(pool.getId())
                            .poolName(pool.getPoolName())
                            .categoryId(pool.getCategoryId())
                            .categoryName(cat.getCategoryName())
                            .gender(pool.getGender())
                            .build());
        }

        // 2. 扫描 wz 得到全部基础样式, 一个池都没引用的样式也会列出来 (refCount = 0)
        List<BeautyStyleOverviewDTO> result = new ArrayList<>();
        for (Map.Entry<Integer, Integer> entry : scanWzStyles(type).entrySet()) {
            Integer styleGender = entry.getValue();
            if (gender != null && gender >= 0 && !gender.equals(styleGender)) {
                continue;
            }
            List<BeautyPoolRefDTO> pools = new ArrayList<>(
                    refMap.getOrDefault(entry.getKey(), Collections.emptyList()));
            pools.sort(Comparator.comparing(BeautyPoolRefDTO::getPoolId));
            result.add(BeautyStyleOverviewDTO.builder()
                    .styleId(entry.getKey())
                    .styleName(StringInfoProvider.getBeautyStyleName(type, entry.getKey()))
                    .beautyType(type)
                    .gender(styleGender)
                    .colorCount(colorCountOf(type))
                    .refCount(pools.size())
                    .pools(pools)
                    .build());
        }
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int addStylesToPools(BeautyStyleBatchAddDTO dto) {
        RequireUtil.requireNotNull(dto, "参数不能为空");

        LinkedHashSet<Integer> styleIds = new LinkedHashSet<>();
        if (dto.getStyleIds() != null) {
            for (Integer styleId : dto.getStyleIds()) {
                if (styleId != null && styleId >= 0) {
                    styleIds.add(styleId);
                }
            }
        }
        LinkedHashSet<Integer> poolIds = new LinkedHashSet<>();
        if (dto.getPoolIds() != null) {
            for (Integer poolId : dto.getPoolIds()) {
                if (poolId != null && poolId > 0) {
                    poolIds.add(poolId);
                }
            }
        }
        RequireUtil.requireNotEmpty(styleIds, "请选择要加入的样式");
        RequireUtil.requireNotEmpty(poolIds, "请选择目标资源池");

        int inserted = 0;
        for (Integer poolId : poolIds) {
            // 池不存在直接跳过, 不让整批失败
            if (poolMapper.selectOneById(poolId) == null) {
                continue;
            }
            List<NpcBeautyPoolItemDO> existing = poolItemMapper.selectListByQuery(QueryWrapper.create()
                    .from(NPC_BEAUTY_POOL_ITEM_D_O)
                    .where(NPC_BEAUTY_POOL_ITEM_D_O.POOL_ID.eq(poolId)));
            Set<Integer> existingStyleIds = existing.stream()
                    .map(NpcBeautyPoolItemDO::getStyleId)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toSet());
            int sortOrder = existing.stream()
                    .map(NpcBeautyPoolItemDO::getSortOrder)
                    .filter(Objects::nonNull)
                    .mapToInt(Integer::intValue)
                    .max()
                    .orElse(0);
            for (Integer styleId : styleIds) {
                if (existingStyleIds.contains(styleId)) {
                    continue;
                }
                poolItemMapper.insertSelective(NpcBeautyPoolItemDO.builder()
                        .poolId(poolId)
                        .styleId(styleId)
                        .sortOrder(++sortOrder)
                        .build());
                existingStyleIds.add(styleId);
                inserted++;
            }
        }
        return inserted;
    }

    /**
     * 该 NPC 已绑定的资源池 (含池内样式明细)
     */
    private List<BeautyMappingDTO> getMappingList(int npcId) {
        List<NpcBeautyMappingDO> mappings = mappingMapper.selectListByQuery(QueryWrapper.create()
                .from(NPC_BEAUTY_MAPPING_D_O)
                .where(NPC_BEAUTY_MAPPING_D_O.NPC_ID.eq(npcId))
                .orderBy(NPC_BEAUTY_MAPPING_D_O.SORT_ORDER.asc(), NPC_BEAUTY_MAPPING_D_O.ID.asc()));
        if (mappings.isEmpty()) {
            return Collections.emptyList();
        }

        Map<Integer, NpcBeautyCatDO> catMap = loadCategoryMap();
        Map<Integer, NpcBeautyPoolDO> poolMap = poolMapper.selectListByQuery(
                        QueryWrapper.create().from(NPC_BEAUTY_POOL_D_O)).stream()
                .filter(pool -> pool.getId() != null)
                .collect(Collectors.toMap(NpcBeautyPoolDO::getId, pool -> pool, (a, b) -> a));

        List<Integer> poolIds = mappings.stream()
                .map(NpcBeautyMappingDO::getPoolId)
                .filter(Objects::nonNull)
                .distinct()
                .collect(Collectors.toList());

        Map<Integer, List<BeautyPoolItemDTO>> itemGroup = loadPoolItemDTOList(poolIds, loadPoolBeautyTypeMap(poolIds));

        String npcName = resolveNpcName(npcId);
        List<BeautyMappingDTO> result = new ArrayList<>();
        for (NpcBeautyMappingDO mapping : mappings) {
            NpcBeautyPoolDO pool = mapping.getPoolId() == null ? null : poolMap.get(mapping.getPoolId());
            NpcBeautyCatDO cat = pool == null ? null : catMap.get(pool.getCategoryId());
            List<BeautyPoolItemDTO> items = itemGroup.getOrDefault(mapping.getPoolId(), Collections.emptyList());

            result.add(BeautyMappingDTO.builder()
                    .id(mapping.getId())
                    .npcId(mapping.getNpcId())
                    .poolId(mapping.getPoolId())
                    .couponItemId(mapping.getCouponItemId())
                    .sortOrder(mapping.getSortOrder())
                    .isActive(mapping.getIsActive())
                    .npcName(npcName)
                    .poolName(pool == null ? null : pool.getPoolName())
                    .categoryId(pool == null ? null : pool.getCategoryId())
                    .categoryName(cat == null ? null : cat.getCategoryName())
                    .beautyType(cat == null ? null : cat.getBeautyType())
                    .serviceMode(cat == null ? null : cat.getServiceMode())
                    .gender(pool == null ? null : pool.getGender())
                    .templateId(cat == null ? null : cat.getTemplateId())
                    .isRandom(cat == null ? null : cat.getIsRandom())
                    .itemCount(items.size())
                    .items(items)
                    .build());
        }
        return result;
    }

    private Map<Integer, NpcBeautyCatDO> loadCategoryMap() {
        return getCategoryList().stream()
                .filter(cat -> cat.getId() != null)
                .collect(Collectors.toMap(NpcBeautyCatDO::getId, cat -> cat, (a, b) -> a, LinkedHashMap::new));
    }

    private Map<Integer, Long> loadPoolItemCountMap() {
        return poolItemMapper.selectListByQuery(QueryWrapper.create().from(NPC_BEAUTY_POOL_ITEM_D_O)).stream()
                .filter(item -> item.getPoolId() != null)
                .collect(Collectors.groupingBy(NpcBeautyPoolItemDO::getPoolId, Collectors.counting()));
    }

    private BeautyPoolDTO toPoolDTO(NpcBeautyPoolDO pool, NpcBeautyCatDO cat, long itemCount) {
        return BeautyPoolDTO.builder()
                .id(pool.getId())
                .poolName(pool.getPoolName())
                .categoryId(pool.getCategoryId())
                .gender(pool.getGender())
                .isActive(pool.getIsActive())
                .categoryName(cat == null ? null : cat.getCategoryName())
                .beautyType(cat == null ? null : cat.getBeautyType())
                .serviceMode(cat == null ? null : cat.getServiceMode())
                .itemCount((int) itemCount)
                .build();
    }

    /**
     * 资源池 -> 美容类型 (HAIR / FACE / SKIN), 用于回填样式中文名
     */
    private Map<Integer, String> loadPoolBeautyTypeMap(List<Integer> poolIds) {
        if (poolIds == null || poolIds.isEmpty()) {
            return Collections.emptyMap();
        }
        Map<Integer, NpcBeautyCatDO> catMap = loadCategoryMap();
        Map<Integer, String> result = new HashMap<>();
        List<NpcBeautyPoolDO> pools = poolMapper.selectListByQuery(QueryWrapper.create()
                .from(NPC_BEAUTY_POOL_D_O)
                .where(NPC_BEAUTY_POOL_D_O.ID.in(poolIds)));
        for (NpcBeautyPoolDO pool : pools) {
            if (pool.getId() == null) {
                continue;
            }
            NpcBeautyCatDO cat = catMap.get(pool.getCategoryId());
            result.put(pool.getId(), cat == null || cat.getBeautyType() == null ? "" : cat.getBeautyType());
        }
        return result;
    }

    /**
     * 按资源池分组加载样式明细, 并回填发型/脸型中文名
     */
    private Map<Integer, List<BeautyPoolItemDTO>> loadPoolItemDTOList(List<Integer> poolIds,
                                                                      Map<Integer, String> beautyTypeMap) {
        Map<Integer, List<BeautyPoolItemDTO>> itemGroup = new LinkedHashMap<>();
        if (poolIds == null || poolIds.isEmpty()) {
            return itemGroup;
        }
        List<NpcBeautyPoolItemDO> items = poolItemMapper.selectListByQuery(QueryWrapper.create()
                .from(NPC_BEAUTY_POOL_ITEM_D_O)
                .where(NPC_BEAUTY_POOL_ITEM_D_O.POOL_ID.in(poolIds))
                .orderBy(NPC_BEAUTY_POOL_ITEM_D_O.SORT_ORDER.asc(), NPC_BEAUTY_POOL_ITEM_D_O.ID.asc()));
        for (NpcBeautyPoolItemDO item : items) {
            String beautyType = beautyTypeMap == null ? null : beautyTypeMap.get(item.getPoolId());
            itemGroup.computeIfAbsent(item.getPoolId(), key -> new ArrayList<>())
                    .add(toPoolItemDTO(item, beautyType));
        }
        return itemGroup;
    }

    private BeautyPoolItemDTO toPoolItemDTO(NpcBeautyPoolItemDO item, String beautyType) {
        return BeautyPoolItemDTO.builder()
                .id(item.getId())
                .poolId(item.getPoolId())
                .styleId(item.getStyleId())
                .sortOrder(item.getSortOrder())
                .beautyType(beautyType)
                .styleName(StringInfoProvider.getBeautyStyleName(beautyType, item.getStyleId()))
                .build();
    }

    /**
     * NPC 名称兜底, 避免 String.wz 中不存在时列表缺行
     */
    private String resolveNpcName(int npcId) {
        String npcName = StringInfoProvider.getNPCName(npcId);
        return RequireUtil.isEmpty(npcName) ? ("未知NPC " + npcId) : npcName;
    }
    // =========================================================================
    // 台词 (npc_dialog, dialog_type = beauty)
    // =========================================================================

    @Override
    public List<NpcDialog> loadDialogList(int npcId, String dialogType) {
        return dialogMapper.selectListByQuery(QueryWrapper.create()
                .from(NPC_DIALOG)
                .where(NPC_DIALOG.DIALOG_TYPE.eq(normalizeDialogType(dialogType)))
                .and(NPC_DIALOG.NPC_ID.eq(npcId))
                .orderBy(NPC_DIALOG.ID.asc()));
    }

    @Override
    public Map<String, String> loadDialogMap(int npcId, String dialogType) {
        String type = normalizeDialogType(dialogType);
        Map<String, String> result = new LinkedHashMap<>();
        // 1. 先铺全局兜底台词 (npc_id = 0)
        for (NpcDialog dialog : loadDialogList(0, type)) {
            result.put(dialog.getDialogKey(), dialog.getDialogText());
        }
        // 2. NPC 专属台词覆盖全局台词
        if (npcId > 0) {
            for (NpcDialog dialog : loadDialogList(npcId, type)) {
                result.put(dialog.getDialogKey(), dialog.getDialogText());
            }
        }
        return result;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveDialog(NpcDialog dialog) {
        RequireUtil.requireNotNull(dialog, "台词数据不能为空");
        RequireUtil.requireNotNull(dialog.getNpcId(), "npcId 不能为空");
        RequireUtil.requireNotEmpty(dialog.getDialogKey(), "台词 key 不能为空");
        if (RequireUtil.isEmpty(dialog.getDialogType())) {
            dialog.setDialogType(DEFAULT_DIALOG_TYPE);
        }
        if (dialog.getTemplateId() == null) {
            dialog.setTemplateId(DEFAULT_TEMPLATE_ID);
        }
        dialog.setId(normalizeId(dialog.getId()));
        if (dialog.getId() == null) {
            dialogMapper.insertSelective(dialog);
        } else {
            dialogMapper.update(dialog);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteDialog(Integer id) {
        RequireUtil.requireNotNull(id, "台词ID不能为空");
        dialogMapper.deleteById(id);
    }

    // =========================================================================
    // NPC 与资源池绑定关系 (npc_beauty_mapping)
    // =========================================================================

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void saveMapping(BeautyMappingDTO dto) {
        RequireUtil.requireNotNull(dto, "绑定数据不能为空");
        RequireUtil.requireNotNull(dto.getNpcId(), "npcId 不能为空");
        RequireUtil.requireNotNull(dto.getPoolId(), "资源池不能为空");
        RequireUtil.requireNotNull(dto.getCouponItemId(), "会员卡/道具 ID 不能为空");
        RequireUtil.requireTrue(poolMapper.selectOneById(dto.getPoolId()) != null,
                "资源池不存在: " + dto.getPoolId());

        Integer id = normalizeId(dto.getId());
        QueryWrapper duplicateQuery = QueryWrapper.create()
                .from(NPC_BEAUTY_MAPPING_D_O)
                .where(NPC_BEAUTY_MAPPING_D_O.NPC_ID.eq(dto.getNpcId()))
                .and(NPC_BEAUTY_MAPPING_D_O.POOL_ID.eq(dto.getPoolId()));
        if (id != null) {
            duplicateQuery.and(NPC_BEAUTY_MAPPING_D_O.ID.ne(id));
        }
        RequireUtil.requireTrue(mappingMapper.selectCountByQuery(duplicateQuery) == 0,
                "该 NPC 已绑定此资源池, 请勿重复添加");

        NpcBeautyMappingDO entity = NpcBeautyMappingDO.builder()
                .id(id)
                .npcId(dto.getNpcId())
                .poolId(dto.getPoolId())
                .couponItemId(dto.getCouponItemId())
                .sortOrder(dto.getSortOrder() == null ? 0 : dto.getSortOrder())
                .isActive(dto.getIsActive() == null || dto.getIsActive())
                .build();
        if (entity.getId() == null) {
            mappingMapper.insertSelective(entity);
        } else {
            mappingMapper.update(entity);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteMapping(Integer id) {
        RequireUtil.requireNotNull(id, "绑定ID不能为空");
        mappingMapper.deleteById(id);
    }

    // =========================================================================
    // 资源池 (npc_beauty_pool)
    // =========================================================================

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void savePool(BeautyPoolDTO dto) {
        RequireUtil.requireNotNull(dto, "资源池数据不能为空");
        RequireUtil.requireNotEmpty(dto.getPoolName(), "资源池标识不能为空");
        RequireUtil.requireNotNull(dto.getCategoryId(), "所属分类不能为空");
        RequireUtil.requireTrue(catMapper.selectOneById(dto.getCategoryId()) != null,
                "分类不存在: " + dto.getCategoryId());

        NpcBeautyPoolDO entity = NpcBeautyPoolDO.builder()
                .id(normalizeId(dto.getId()))
                .poolName(dto.getPoolName().trim())
                .categoryId(dto.getCategoryId())
                .gender(dto.getGender() == null ? -1 : dto.getGender())
                .isActive(dto.getIsActive() == null || dto.getIsActive())
                .build();
        if (entity.getId() == null) {
            poolMapper.insertSelective(entity);
        } else {
            poolMapper.update(entity);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deletePool(Integer id) {
        RequireUtil.requireNotNull(id, "资源池ID不能为空");
        // 1. 级联删除池内样式明细
        poolItemMapper.deleteByQuery(QueryWrapper.create()
                .from(NPC_BEAUTY_POOL_ITEM_D_O)
                .where(NPC_BEAUTY_POOL_ITEM_D_O.POOL_ID.eq(id)));
        // 2. 级联删除 NPC 绑定关系
        mappingMapper.deleteByQuery(QueryWrapper.create()
                .from(NPC_BEAUTY_MAPPING_D_O)
                .where(NPC_BEAUTY_MAPPING_D_O.POOL_ID.eq(id)));
        // 3. 删除资源池
        poolMapper.deleteById(id);
    }
    // =========================================================================
    // 资源池样式明细 (npc_beauty_pool_item)
    // =========================================================================

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void savePoolItem(BeautyPoolItemDTO dto) {
        RequireUtil.requireNotNull(dto, "样式明细不能为空");
        RequireUtil.requireNotNull(dto.getPoolId(), "资源池不能为空");
        RequireUtil.requireNotNull(dto.getStyleId(), "样式ID不能为空");
        RequireUtil.requireTrue(poolMapper.selectOneById(dto.getPoolId()) != null,
                "资源池不存在: " + dto.getPoolId());

        Integer id = normalizeId(dto.getId());
        QueryWrapper duplicateQuery = QueryWrapper.create()
                .from(NPC_BEAUTY_POOL_ITEM_D_O)
                .where(NPC_BEAUTY_POOL_ITEM_D_O.POOL_ID.eq(dto.getPoolId()))
                .and(NPC_BEAUTY_POOL_ITEM_D_O.STYLE_ID.eq(dto.getStyleId()));
        if (id != null) {
            duplicateQuery.and(NPC_BEAUTY_POOL_ITEM_D_O.ID.ne(id));
        }
        RequireUtil.requireTrue(poolItemMapper.selectCountByQuery(duplicateQuery) == 0,
                "该资源池已存在样式 " + dto.getStyleId());

        NpcBeautyPoolItemDO entity = NpcBeautyPoolItemDO.builder()
                .id(id)
                .poolId(dto.getPoolId())
                .styleId(dto.getStyleId())
                .sortOrder(dto.getSortOrder() == null ? 0 : dto.getSortOrder())
                .build();
        if (entity.getId() == null) {
            poolItemMapper.insertSelective(entity);
        } else {
            poolItemMapper.update(entity);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void savePoolItems(BeautyPoolItemBatchDTO dto) {
        RequireUtil.requireNotNull(dto, "样式明细不能为空");
        RequireUtil.requireNotNull(dto.getPoolId(), "资源池不能为空");
        RequireUtil.requireTrue(poolMapper.selectOneById(dto.getPoolId()) != null,
                "资源池不存在: " + dto.getPoolId());

        // 去重并保持前端传入的顺序 (顺序即 sort_order; 皮肤样式 ID 为 0 也合法)
        LinkedHashSet<Integer> styleIds = new LinkedHashSet<>();
        if (dto.getStyleIds() != null) {
            for (Integer styleId : dto.getStyleIds()) {
                if (styleId != null && styleId >= 0) {
                    styleIds.add(styleId);
                }
            }
        }

        // 整池覆盖: 先清空再按顺序写入
        poolItemMapper.deleteByQuery(QueryWrapper.create()
                .from(NPC_BEAUTY_POOL_ITEM_D_O)
                .where(NPC_BEAUTY_POOL_ITEM_D_O.POOL_ID.eq(dto.getPoolId())));

        int sortOrder = 1;
        for (Integer styleId : styleIds) {
            poolItemMapper.insertSelective(NpcBeautyPoolItemDO.builder()
                    .poolId(dto.getPoolId())
                    .styleId(styleId)
                    .sortOrder(sortOrder++)
                    .build());
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deletePoolItem(Integer id) {
        RequireUtil.requireNotNull(id, "样式明细ID不能为空");
        poolItemMapper.deleteById(id);
    }

    // =========================================================================
    // Character.wz 发型 / 脸型 基础样式读取
    // =========================================================================

    @Override
    public List<BeautyWzStyleDTO> listWzStyles(String beautyType, Integer gender, Integer poolId) {
        String type = normalizeBeautyType(beautyType);
        // 皮肤等类型不存在 Character.wz 样式表, 直接返回空列表由前端手工填写 ID
        if (!TYPE_HAIR.equals(type) && !TYPE_FACE.equals(type)) {
            return Collections.emptyList();
        }

        Set<Integer> configuredStyleIds = poolId == null
                ? Collections.emptySet()
                : loadConfiguredStyleIds(poolId);

        List<BeautyWzStyleDTO> result = new ArrayList<>();
        for (Map.Entry<Integer, Integer> entry : scanWzStyles(type).entrySet()) {
            Integer styleGender = entry.getValue();
            if (gender != null && gender >= 0 && !gender.equals(styleGender)) {
                continue;
            }
            result.add(BeautyWzStyleDTO.builder()
                    .styleId(entry.getKey())
                    .beautyType(type)
                    .gender(styleGender)
                    .styleName(StringInfoProvider.getBeautyStyleName(type, entry.getKey()))
                    .colorCount(colorCountOf(type))
                    .configured(configuredStyleIds.contains(entry.getKey()))
                    .build());
        }
        return result;
    }

    /**
     * 扫描 Character.wz 目录, 返回 基础样式ID -> 性别
     * 只保留最基础的那一个样式 (颜色偏移由游戏内 resolveStyleList 自动推导)
     */
    private Map<Integer, Integer> scanWzStyles(String beautyType) {
        TreeMap<Integer, Integer> styles = new TreeMap<>();
        Path directory = resolveWzStyleDir(beautyType);
        if (directory == null) {
            return styles;
        }
        try (DirectoryStream<Path> stream = Files.newDirectoryStream(directory, IMG_XML_PATTERN)) {
            for (Path file : stream) {
                Integer rawStyleId = parseWzStyleId(file.getFileName().toString());
                if (rawStyleId == null) {
                    continue;
                }
                Integer gender = resolveWzGender(beautyType, rawStyleId);
                if (gender == null) {
                    continue;
                }
                styles.putIfAbsent(baseStyleId(beautyType, rawStyleId), gender);
            }
        } catch (IOException e) {
            log.error("读取 Character.wz 美容样式目录失败: {}", directory, e);
        }
        return styles;
    }

    /**
     * 00030000.img.xml -> 30000
     */
    private Integer parseWzStyleId(String fileName) {
        if (fileName == null || !fileName.endsWith(IMG_XML_SUFFIX)) {
            return null;
        }
        String number = fileName.substring(0, fileName.length() - IMG_XML_SUFFIX.length());
        try {
            return Integer.valueOf(number.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    /**
     * 由官方 ID 区间推导性别, 不在支持区间内返回 null (该文件不会被展示)
     */
    private Integer resolveWzGender(String beautyType, int styleId) {
        int[][] ranges = TYPE_FACE.equals(beautyType) ? FACE_GENDER_RANGES : HAIR_GENDER_RANGES;
        for (int[] range : ranges) {
            if (styleId >= range[0] && styleId <= range[1]) {
                return range[2];
            }
        }
        return null;
    }

    /**
     * 取最基础样式 ID
     * 发型: 同款 8 种颜色为 styleId + 0 ~ +7, 基础 ID 为 30000 / 30010 / 30020 ...
     * 脸型: 同款 8 种眼睛颜色为 styleId + 0 / +100 ... +700, 基础 ID 为 20000 / 20001 / 20002 ...
     */
    private int baseStyleId(String beautyType, int styleId) {
        if (TYPE_FACE.equals(beautyType)) {
            return styleId - (((styleId / 100) % 10) * 100);
        }
        return styleId - (styleId % 10);
    }

    private int colorCountOf(String beautyType) {
        return TYPE_FACE.equals(beautyType) ? FACE_COLOR_COUNT : HAIR_COLOR_COUNT;
    }

    private Set<Integer> loadConfiguredStyleIds(Integer poolId) {
        return poolItemMapper.selectListByQuery(QueryWrapper.create()
                        .from(NPC_BEAUTY_POOL_ITEM_D_O)
                        .where(NPC_BEAUTY_POOL_ITEM_D_O.POOL_ID.eq(poolId))).stream()
                .map(NpcBeautyPoolItemDO::getStyleId)
                .filter(Objects::nonNull)
                .collect(Collectors.toSet());
    }

    /**
     * 定位 Character.wz/Hair 或 Character.wz/Face 目录
     * 与 {@link org.gms.provider.wz.WzFileResolver} 一致: 语言目录 (wz-{language}) 优先, 其次 wz
     */
    private Path resolveWzStyleDir(String beautyType) {
        String subDirectory = TYPE_FACE.equals(beautyType) ? WZ_FACE_DIR : WZ_HAIR_DIR;
        Path relativeTail = Path.of(WzFiles.CHARACTER.getFileName(), subDirectory);

        List<String> wzDirectories = new ArrayList<>();
        String language = serviceProperty == null ? null : serviceProperty.getLanguage();
        if (!RequireUtil.isEmpty(language)) {
            wzDirectories.add(WzFiles.DIRECTORY + "-" + language);
        }
        wzDirectories.add(WzFiles.DIRECTORY);

        List<Path> tried = new ArrayList<>();
        for (Path baseDirectory : wzBaseDirectories()) {
            for (String wzDirectory : wzDirectories) {
                Path directory = baseDirectory.resolve(wzDirectory).resolve(relativeTail);
                tried.add(directory);
                if (Files.isDirectory(directory)) {
                    return directory;
                }
            }
        }
        log.warn("未找到 Character.wz 样式目录 {}, 已尝试的路径: {}", relativeTail, tried);
        return null;
    }

    /**
     * wz 根目录候选: 兼容从 gms-handler 运行与从仓库根目录运行两种情况
     */
    private List<Path> wzBaseDirectories() {
        Set<Path> candidates = new LinkedHashSet<>();
        Path userDir = Path.of(System.getProperty("user.dir", ".")).toAbsolutePath().normalize();
        candidates.add(userDir);
        candidates.add(userDir.resolve("gms-server").resolve("gms-handler"));
        candidates.add(userDir.resolve("gms-handler"));
        Path parent = userDir.getParent();
        if (parent != null) {
            candidates.add(parent.resolve("gms-handler"));
        }
        return new ArrayList<>(candidates);
    }

    // =========================================================================
    // 通用辅助
    // =========================================================================

    private String normalizeDialogType(String dialogType) {
        return RequireUtil.isEmpty(dialogType) ? DEFAULT_DIALOG_TYPE : dialogType.trim();
    }

    private String normalizeBeautyType(String beautyType) {
        return RequireUtil.isEmpty(beautyType) ? TYPE_HAIR : beautyType.trim().toUpperCase(Locale.ROOT);
    }

    /**
     * 前台可能传 0 表示新增, 统一转成 null
     */
    private Integer normalizeId(Integer id) {
        return id == null || id <= 0 ? null : id;
    }
}
