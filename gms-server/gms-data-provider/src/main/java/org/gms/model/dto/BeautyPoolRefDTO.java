package org.gms.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 引用某个样式的资源池 (用于样式总览)
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/14
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BeautyPoolRefDTO {

    private Integer poolId;

    private String poolName;

    private Integer categoryId;

    /**
     * 分类名称, 例如 "剪发 (VIP 优惠券)"
     */
    private String categoryName;

    /**
     * 资源池适用性别: 0=男, 1=女, -1=通用
     */
    private Integer gender;
}