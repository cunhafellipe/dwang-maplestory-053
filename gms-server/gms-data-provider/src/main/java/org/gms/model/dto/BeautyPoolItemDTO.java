package org.gms.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 资源池样式明细 (npc_beauty_pool_item) 保存 DTO
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/13
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BeautyPoolItemDTO {

    /**
     * 明细主键 (null 或 0 表示新增)
     */
    private Integer id;

    /**
     * 所属资源池 ID (npc_beauty_pool.id)
     */
    private Integer poolId;

    /**
     * 基础样式 ID (发型 30000 起 / 脸型 20000 起 / 皮肤 0 起)
     */
    private Integer styleId;

    /**
     * 排序
     */
    private Integer sortOrder;

    // ================= 以下为只读展示字段 (由后端回填, 保存时忽略) =================

    /**
     * 样式中文名 (发型/脸型, 取自 String.wz/Eqp.img/Eqp/{Hair|Face}/{styleId}/name)
     * 皮肤等取不到名字的类型为 null
     */
    private String styleName;

    /**
     * 该明细所属资源池对应的美容类型 HAIR / FACE / SKIN
     */
    private String beautyType;
}
