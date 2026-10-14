package org.gms.model.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 资源池样式明细批量保存 DTO (整池覆盖式重建)
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/13
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BeautyPoolItemBatchDTO {

    /**
     * 目标资源池 ID
     */
    private Integer poolId;

    /**
     * 覆盖后的完整样式 ID 列表 (顺序即 sort_order)
     */
    private List<Integer> styleIds;
}
