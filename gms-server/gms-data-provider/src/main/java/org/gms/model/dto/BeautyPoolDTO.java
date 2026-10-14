package org.gms.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 美容资源池 (npc_beauty_pool) 保存/展示 DTO
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/13
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BeautyPoolDTO {

    /**
     * 资源池主键 (null 或 0 表示新增)
     */
    private Integer id;

    /**
     * 资源池标识
     */
    private String poolName;

    /**
     * 关联 npc_beauty_cat.id
     */
    private Integer categoryId;

    /**
     * 适用性别: 0=男, 1=女, -1=通用
     */
    private Integer gender;

    /**
     * 开关: true=启用, false=停用
     */
    private Boolean isActive;

    // ================= 以下为只读展示字段 (由后端回填, 保存时忽略) =================

    private String categoryName;

    private String beautyType;

    private String serviceMode;

    /**
     * 池内样式明细数量
     */
    private Integer itemCount;
}
