package org.gms.service;

import java.util.List;
import java.util.Map;

import org.gms.dao.entity.NpcBeautyCatDO;
import org.gms.dao.entity.NpcDialog;
import org.gms.model.dto.BeautyMappingDTO;
import org.gms.model.dto.BeautyPoolDTO;
import org.gms.model.dto.BeautyPoolItemBatchDTO;
import org.gms.model.dto.BeautyPoolItemDTO;
import org.gms.model.dto.BeautySearchRtnDTO;
import org.gms.model.dto.BeautyStyleBatchAddDTO;
import org.gms.model.dto.BeautyStyleOverviewDTO;
import org.gms.model.dto.BeautyWzStyleDTO;
import org.gms.model.dto.NpcBeautyDetailDTO;

/**
 * NPC 美容/美发 管理后台服务 (npc_beauty_cat / npc_beauty_mapping / npc_beauty_pool / npc_beauty_pool_item)
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/13
 */
public interface NpcBeautyAdminService {

    /**
     * 获取所有配置了美容业务的 NPC (npc_function_list.func_type = BEAUTY, 并补充仅存在于绑定表中的 NPC)
     */
    List<BeautySearchRtnDTO> getBeautyList();

    /**
     * 获取指定 NPC 的美容配置详情 (分类 / 资源池 / 绑定关系 / 台词一次性返回)
     */
    NpcBeautyDetailDTO getNpcBeautyDetail(int npcId);

    /**
     * 获取全量美容主分类 (npc_beauty_cat, 只读展示)
     */
    List<NpcBeautyCatDO> getCategoryList();

    /**
     * 获取全量美容资源池 (npc_beauty_pool, 含分类名与明细数量)
     */
    List<BeautyPoolDTO> getPoolList();

    /**
     * 获取指定资源池的样式明细 (npc_beauty_pool_item, 含发型/脸型中文名)
     */
    List<BeautyPoolItemDTO> getPoolItemList(Integer poolId);

    /**
     * 样式总览: 列出 wz 里全部发型/脸型基础样式, 并带上"被哪些资源池引用 / 引用次数"
     *
     * @param beautyType HAIR / FACE
     * @param gender     0=男 1=女, 其它值(含 null / -1)表示不过滤
     */
    List<BeautyStyleOverviewDTO> getStyleOverview(String beautyType, Integer gender);

    /**
     * 批量把样式加入资源池 (已存在的样式自动跳过, sort_order 追加到末尾)
     *
     * @return 实际新增的明细条数
     */
    int addStylesToPools(BeautyStyleBatchAddDTO dto);

    /**
     * 获取指定 NPC 的美容台词 Map (npc_id = 0 的全局台词兜底, NPC 专属台词覆盖)
     */
    Map<String, String> loadDialogMap(int npcId, String dialogType);

    /**
     * 获取指定 NPC 自己配置的美容台词列表
     */
    List<NpcDialog> loadDialogList(int npcId, String dialogType);

    /**
     * 新增或修改 NPC 与资源池的绑定关系 (id 为空时新增)
     */
    void saveMapping(BeautyMappingDTO dto);

    /**
     * 删除绑定关系 (不会删除资源池及其明细)
     */
    void deleteMapping(Integer id);

    /**
     * 新增或修改资源池 (id 为空时新增)
     */
    void savePool(BeautyPoolDTO dto);

    /**
     * 删除资源池 (级联删除其样式明细与 NPC 绑定关系)
     */
    void deletePool(Integer id);

    /**
     * 新增或修改单条资源池样式明细 (id 为空时新增)
     */
    void savePoolItem(BeautyPoolItemDTO dto);

    /**
     * 整池覆盖式保存样式明细 (顺序即 sort_order)
     */
    void savePoolItems(BeautyPoolItemBatchDTO dto);

    /**
     * 删除单条资源池样式明细
     */
    void deletePoolItem(Integer id);

    /**
     * 新增或修改 NPC 美容台词 (id 为空时新增)
     */
    void saveDialog(NpcDialog dialog);

    /**
     * 删除 NPC 美容台词
     */
    void deleteDialog(Integer id);

    /**
     * 读取 Character.wz 的 Hair / Face 目录, 返回可用于配置的基础样式列表
     *
     * @param beautyType HAIR(发型) / FACE(脸型), 其它类型(如 SKIN) 返回空列表
     * @param gender     0=男 1=女, 其它值(含 -1 / null) 表示不过滤
     * @param poolId     可选, 传入时会标记样式是否已配置在该资源池中
     */
    List<BeautyWzStyleDTO> listWzStyles(String beautyType, Integer gender, Integer poolId);
}
