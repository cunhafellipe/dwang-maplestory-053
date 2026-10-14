package org.gms.model.dto;

import java.util.List;

import org.gms.dao.entity.NpcBeautyCatDO;
import org.gms.dao.entity.NpcDialog;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * NPC 美容配置详情 (详情页一次性返回, 避免前端多次请求)
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/13
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class NpcBeautyDetailDTO {

    /**
     * npc_function_list.id (未登记 BEAUTY 业务时为空)
     */
    private Integer funcId;

    private Integer npcId;

    private String npcName;

    private String mapName;

    /**
     * 全量美容主分类 (npc_beauty_cat, 只读展示)
     */
    private List<NpcBeautyCatDO> categories;

    /**
     * 全量资源池 (npc_beauty_pool, 用于下拉选择与增删改)
     */
    private List<BeautyPoolDTO> pools;

    /**
     * 该 NPC 已绑定的美容池 (npc_beauty_mapping + npc_beauty_pool_item)
     */
    private List<BeautyMappingDTO> mappings;

    /**
     * 该 NPC 的美容台词 (npc_dialog, dialog_type = beauty)
     */
    private List<NpcDialog> dialogs;
}
