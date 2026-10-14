package org.gms.model.dto;

import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * NPC 美容/美发 列表查询条件
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/13
 */
@EqualsAndHashCode(callSuper = true)
@Data
public class BeautySearchReqDTO extends BasePageDTO {

    private Integer funcId;

    private Integer npcId;

    private String npcName;
}
