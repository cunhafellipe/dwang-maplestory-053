package org.gms.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Character.wz 中可配置的美容基础样式 (只取最基础的那一个, 颜色偏移由游戏内自动推导)
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/13
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BeautyWzStyleDTO {

    /**
     * 基础样式 ID
     * 发型: 30000 / 30010 / 30020 ... (同款 8 种颜色为 styleId + 0 ~ +7)
     * 脸型: 20000 / 20001 / 20002 ... (同款 8 种眼睛颜色为 styleId + 0 / +100 ... +700)
     */
    private Integer styleId;

    /**
     * HAIR / FACE
     */
    private String beautyType;

    /**
     * 适用性别: 0=男, 1=女 (由官方 ID 区间推导)
     */
    private Integer gender;

    /**
     * 样式中文名 (取自 String.wz/Eqp.img/Eqp/{Hair|Face}/{styleId}/name), 取不到为 null
     */
    private String styleName;

    /**
     * 可用颜色数量 (发型 8 种颜色, 脸型 8 种眼睛颜色)
     */
    private Integer colorCount;

    /**
     * 传了 poolId 时: 该样式是否已配置在该资源池中
     */
    private Boolean configured;
}
