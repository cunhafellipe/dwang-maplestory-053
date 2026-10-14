package org.gms.model.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 批量把样式加入资源池
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/14
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BeautyStyleBatchAddDTO {

    /**
     * 要加入的样式 ID 列表
     */
    private List<Integer> styleIds;

    /**
     * 目标资源池 ID 列表 (已存在的样式会自动跳过)
     */
    private List<Integer> poolIds;
}