package org.gms.model.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * NPC 与美容池绑定关系 (npc_beauty_mapping) 保存/展示 DTO
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/13
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BeautyMappingDTO {

    /**
     * 绑定关系主键 (null 或 0 表示新增)
     */
    private Integer id;

    /**
     * 绑定 NPC ID
     */
    private Integer npcId;

    /**
     * 关联 npc_beauty_pool.id
     */
    private Integer poolId;

    /**
     * 该 NPC 处理此池子时消耗的专属会员卡/道具 ID
     */
    private Integer couponItemId;

    /**
     * 菜单展示顺序
     */
    private Integer sortOrder;

    /**
     * 开关: true=启用, false=禁用
     */
    private Boolean isActive;

    // ================= 以下为只读展示字段 (由后端回填, 保存时忽略) =================

    private String npcName;

    private String poolName;

    private Integer categoryId;

    private String categoryName;

    /**
     * HAIR / FACE / SKIN
     */
    private String beautyType;

    /**
     * HAIR_CHANGE / HAIR_COLOR / FACE_CHANGE / FACE_COLOR / SKIN_CHANGE
     */
    private String serviceMode;

    /**
     * 资源池适用性别: 0=男, 1=女, -1=通用
     */
    private Integer gender;

    private Integer templateId;

    private Boolean isRandom;

    /**
     * 池内样式明细数量
     */
    private Integer itemCount;

    /**
     * 池内样式明细
     */
    private List<BeautyPoolItemDTO> items;
}
