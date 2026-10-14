package org.gms.model.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 样式总览 (053 wz 里的每一个发型/脸型基础样式 + 被资源池引用的情况)
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/14
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BeautyStyleOverviewDTO {

    /**
     * 基础样式 ID
     */
    private Integer styleId;

    /**
     * 样式中文名
     */
    private String styleName;

    /**
     * HAIR / FACE
     */
    private String beautyType;

    /**
     * 适用性别: 0=男, 1=女
     */
    private Integer gender;

    /**
     * 可用颜色数量
     */
    private Integer colorCount;

    /**
     * 被多少个资源池引用 (0 = 没有任何池在用)
     */
    private Integer refCount;

    /**
     * 引用它的资源池列表
     */
    private List<BeautyPoolRefDTO> pools;
}