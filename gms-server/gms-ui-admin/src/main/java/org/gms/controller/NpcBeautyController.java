package org.gms.controller;

import com.mybatisflex.core.paginate.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.gms.constants.api.ApiConstant;
import org.gms.dao.entity.NpcBeautyCatDO;
import org.gms.dao.entity.NpcDialog;
import org.gms.model.dto.BeautyMappingDTO;
import org.gms.model.dto.BeautyPoolDTO;
import org.gms.model.dto.BeautyPoolItemBatchDTO;
import org.gms.model.dto.BeautyPoolItemDTO;
import org.gms.model.dto.BeautySearchReqDTO;
import org.gms.model.dto.BeautySearchRtnDTO;
import org.gms.model.dto.BeautyStyleBatchAddDTO;
import org.gms.model.dto.BeautyStyleOverviewDTO;
import org.gms.model.dto.BeautyWzStyleDTO;
import org.gms.model.dto.NpcBeautyDetailDTO;
import org.gms.model.dto.ResultBody;
import org.gms.model.dto.SubmitBody;
import org.gms.service.NpcBeautyAdminService;
import org.gms.util.BasePageUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * NPC 美容/美发(剪发/染发/整容/美瞳/皮肤) 管理后台 控制器
 *
 * 涉及表: npc_beauty_cat (只读展示) / npc_beauty_mapping / npc_beauty_pool /
 * npc_beauty_pool_item / npc_dialog(dialog_type = beauty)
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/13
 */
@Tag(name = "NPC美容管理 - " + ApiConstant.LATEST)
@RestController
@RequestMapping("/api/npc-beauty")
public class NpcBeautyController {

    private final NpcBeautyAdminService npcBeautyAdminService;

    @Autowired
    public NpcBeautyController(NpcBeautyAdminService npcBeautyAdminService) {
        this.npcBeautyAdminService = npcBeautyAdminService;
    }

    /**
     * 分页获取配置了美容业务的 NPC 列表
     */
    @Operation(summary = "分页获取美容 NPC 列表")
    @PostMapping("/" + ApiConstant.LATEST + "/getBeautyList")
    public ResultBody<Page<BeautySearchRtnDTO>> getBeautyList(@RequestBody SubmitBody<BeautySearchReqDTO> request) {
        BeautySearchReqDTO condition = request.getData() == null ? new BeautySearchReqDTO() : request.getData();
        String npcName = condition.getNpcName();
        List<BeautySearchRtnDTO> beautyList = npcBeautyAdminService.getBeautyList();
        Page<BeautySearchRtnDTO> page = BasePageUtil.create(beautyList, condition)
                .filter(dto -> condition.getFuncId() == null || condition.getFuncId().equals(dto.getFuncId()))
                .filter(dto -> condition.getNpcId() == null || condition.getNpcId().equals(dto.getNpcId()))
                .filter(dto -> npcName == null || npcName.trim().isEmpty()
                        || (dto.getNpcName() != null && dto.getNpcName().contains(npcName.trim())))
                .page();
        return ResultBody.success(request, page);
    }

    /**
     * 获取指定 NPC 的美容配置详情 (分类 / 资源池 / 绑定关系 / 台词)
     */
    @Operation(summary = "获取 NPC 美容配置详情")
    @GetMapping("/" + ApiConstant.LATEST + "/detail/{npcId}")
    public ResultBody<NpcBeautyDetailDTO> getBeautyDetail(
            @Parameter(description = "NPC ID", required = true) @PathVariable("npcId") int npcId) {
        return ResultBody.success(npcBeautyAdminService.getNpcBeautyDetail(npcId));
    }

    /**
     * 获取美容主分类列表 (npc_beauty_cat, 一般不变, 只读展示)
     */
    @Operation(summary = "获取美容主分类列表 (只读)")
    @GetMapping("/" + ApiConstant.LATEST + "/categories")
    public ResultBody<List<NpcBeautyCatDO>> getCategoryList() {
        return ResultBody.success(npcBeautyAdminService.getCategoryList());
    }

    /**
     * 获取全量美容资源池列表 (含分类名与明细数量)
     */
    @Operation(summary = "获取全量美容资源池列表")
    @GetMapping("/" + ApiConstant.LATEST + "/pools")
    public ResultBody<List<BeautyPoolDTO>> getPoolList() {
        return ResultBody.success(npcBeautyAdminService.getPoolList());
    }

    /**
     * 获取指定资源池的样式明细 (含发型/脸型中文名)
     */
    @Operation(summary = "获取指定资源池的样式明细")
    @GetMapping("/" + ApiConstant.LATEST + "/poolItems/{poolId}")
    public ResultBody<List<BeautyPoolItemDTO>> getPoolItemList(
            @Parameter(description = "资源池 ID", required = true) @PathVariable("poolId") Integer poolId) {
        return ResultBody.success(npcBeautyAdminService.getPoolItemList(poolId));
    }

    /**
     * 样式总览: wz 里全部发型/脸型基础样式 + 被哪些资源池引用 (用于样式管理页)
     */
    @Operation(summary = "样式总览 (含资源池引用情况)")
    @GetMapping("/" + ApiConstant.LATEST + "/styleOverview")
    public ResultBody<List<BeautyStyleOverviewDTO>> getStyleOverview(
            @Parameter(description = "HAIR / FACE") @RequestParam(value = "beautyType", defaultValue = "HAIR") String beautyType,
            @Parameter(description = "0=男 1=女, 不传表示不过滤") @RequestParam(value = "gender", required = false) Integer gender) {
        return ResultBody.success(npcBeautyAdminService.getStyleOverview(beautyType, gender));
    }

    /**
     * 批量把样式加入资源池 (已存在的样式自动跳过)
     */
    @Operation(summary = "批量把样式加入资源池")
    @PostMapping("/" + ApiConstant.LATEST + "/addStylesToPools")
    public ResultBody<Object> addStylesToPools(@RequestBody SubmitBody<BeautyStyleBatchAddDTO> request) {
        return ResultBody.success(request, npcBeautyAdminService.addStylesToPools(request.getData()));
    }

    /**
     * 读取 Character.wz 的 Hair / Face 目录, 返回最基础的样式列表用于配置
     *
     * @param beautyType HAIR(发型) / FACE(脸型)
     * @param gender     0=男 1=女, 不传或 -1 表示不过滤
     * @param poolId     可选, 传入时标记样式是否已配置在该池中
     */
    @Operation(summary = "读取 Character.wz 发型/脸型基础样式")
    @GetMapping("/" + ApiConstant.LATEST + "/wzStyles")
    public ResultBody<List<BeautyWzStyleDTO>> getWzStyles(
            @Parameter(description = "HAIR / FACE") @RequestParam(value = "beautyType", defaultValue = "HAIR") String beautyType,
            @Parameter(description = "0=男 1=女, 不传表示不过滤") @RequestParam(value = "gender", required = false) Integer gender,
            @Parameter(description = "可选, 标记已配置样式") @RequestParam(value = "poolId", required = false) Integer poolId) {
        return ResultBody.success(npcBeautyAdminService.listWzStyles(beautyType, gender, poolId));
    }

    /**
     * 获取指定 NPC 绑定的全量 Key-Value 垂直台词 Map
     */
    @Operation(summary = "获取 NPC 美容台词 Map")
    @GetMapping("/" + ApiConstant.LATEST + "/dialogsMap/{npcId}")
    public ResultBody<Map<String, String>> loadDialogMap(
            @Parameter(description = "NPC ID", required = true) @PathVariable("npcId") int npcId,
            @Parameter(description = "台词类型") @RequestParam(value = "dialogType", defaultValue = "beauty") String dialogType) {
        return ResultBody.success(npcBeautyAdminService.loadDialogMap(npcId, dialogType));
    }

    /**
     * 获取指定 NPC 的美容台词 List
     */
    @Operation(summary = "获取 NPC 美容台词 List")
    @GetMapping("/" + ApiConstant.LATEST + "/dialogs/{npcId}")
    public ResultBody<List<NpcDialog>> getNpcDialogs(
            @Parameter(description = "NPC ID", required = true) @PathVariable("npcId") int npcId,
            @Parameter(description = "台词类型") @RequestParam(value = "dialogType", defaultValue = "beauty") String dialogType) {
        return ResultBody.success(npcBeautyAdminService.loadDialogList(npcId, dialogType));
    }

    /**
     * 新增或修改 NPC 美容台词
     */
    @Operation(summary = "新增或修改 NPC 美容台词")
    @PostMapping("/" + ApiConstant.LATEST + "/saveDialog")
    public ResultBody<Object> saveDialog(@RequestBody SubmitBody<NpcDialog> request) {
        npcBeautyAdminService.saveDialog(request.getData());
        return ResultBody.success(request, null);
    }

    /**
     * 删除 NPC 美容台词
     */
    @Operation(summary = "删除 NPC 美容台词")
    @PostMapping("/" + ApiConstant.LATEST + "/deleteDialog")
    public ResultBody<Object> deleteDialog(@RequestBody SubmitBody<NpcDialog> request) {
        npcBeautyAdminService.deleteDialog(request.getData().getId());
        return ResultBody.success(request, null);
    }

    /**
     * 新增或修改 NPC 与资源池的绑定关系 (会员卡 / 排序 / 开关)
     */
    @Operation(summary = "新增或修改 NPC 美容池绑定关系")
    @PostMapping("/" + ApiConstant.LATEST + "/saveMapping")
    public ResultBody<Object> saveMapping(@RequestBody SubmitBody<BeautyMappingDTO> request) {
        npcBeautyAdminService.saveMapping(request.getData());
        return ResultBody.success(request, null);
    }

    /**
     * 删除 NPC 与资源池的绑定关系
     */
    @Operation(summary = "删除 NPC 美容池绑定关系")
    @PostMapping("/" + ApiConstant.LATEST + "/deleteMapping")
    public ResultBody<Object> deleteMapping(@RequestBody SubmitBody<BeautyMappingDTO> request) {
        npcBeautyAdminService.deleteMapping(request.getData().getId());
        return ResultBody.success(request, null);
    }

    /**
     * 新增或修改资源池
     */
    @Operation(summary = "新增或修改美容资源池")
    @PostMapping("/" + ApiConstant.LATEST + "/savePool")
    public ResultBody<Object> savePool(@RequestBody SubmitBody<BeautyPoolDTO> request) {
        npcBeautyAdminService.savePool(request.getData());
        return ResultBody.success(request, null);
    }

    /**
     * 删除资源池 (级联删除其样式明细与 NPC 绑定关系)
     */
    @Operation(summary = "删除美容资源池 (级联删除明细与绑定)")
    @PostMapping("/" + ApiConstant.LATEST + "/deletePool")
    public ResultBody<Object> deletePool(@RequestBody SubmitBody<BeautyPoolDTO> request) {
        npcBeautyAdminService.deletePool(request.getData().getId());
        return ResultBody.success(request, null);
    }

    /**
     * 新增或修改单条资源池样式明细
     */
    @Operation(summary = "新增或修改美容池样式明细")
    @PostMapping("/" + ApiConstant.LATEST + "/savePoolItem")
    public ResultBody<Object> savePoolItem(@RequestBody SubmitBody<BeautyPoolItemDTO> request) {
        npcBeautyAdminService.savePoolItem(request.getData());
        return ResultBody.success(request, null);
    }

    /**
     * 整池覆盖式保存样式明细 (顺序即 sort_order)
     */
    @Operation(summary = "整池保存美容池样式明细")
    @PostMapping("/" + ApiConstant.LATEST + "/savePoolItems")
    public ResultBody<Object> savePoolItems(@RequestBody SubmitBody<BeautyPoolItemBatchDTO> request) {
        npcBeautyAdminService.savePoolItems(request.getData());
        return ResultBody.success(request, null);
    }

    /**
     * 删除单条资源池样式明细
     */
    @Operation(summary = "删除美容池样式明细")
    @PostMapping("/" + ApiConstant.LATEST + "/deletePoolItem")
    public ResultBody<Object> deletePoolItem(@RequestBody SubmitBody<BeautyPoolItemDTO> request) {
        npcBeautyAdminService.deletePoolItem(request.getData().getId());
        return ResultBody.success(request, null);
    }
}
