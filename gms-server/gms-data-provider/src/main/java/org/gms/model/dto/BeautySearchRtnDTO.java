package org.gms.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * NPC 美容/美发 列表项
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/13
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BeautySearchRtnDTO {

    /**
     * npc_function_list.id
     * 仅存在于 npc_beauty_mapping 中、未登记 BEAUTY 业务的 NPC 此值为空
     */
    private Integer funcId;

    private Integer npcId;

    private String npcName;

    private String mapName;

    /**
     * 已绑定的美容池数量 (npc_beauty_mapping)
     */
    private Integer poolCount;

    /**
     * 是否已在 npc_function_list 中登记 BEAUTY 业务
     */
    private Boolean registered;
}
