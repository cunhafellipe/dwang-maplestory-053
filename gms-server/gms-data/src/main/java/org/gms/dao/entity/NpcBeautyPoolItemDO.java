package org.gms.dao.entity;

import com.mybatisflex.annotation.Id;
import com.mybatisflex.annotation.KeyType;
import com.mybatisflex.annotation.Table;
import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.io.Serial;

/**
 * 资源池样式明细表 实体类。
 *
 * @author 99605
 * @since 2026-10-13
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table("npc_beauty_pool_item")
public class NpcBeautyPoolItemDO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Id(keyType = KeyType.Auto)
    private Integer id;

    /**
     * 关联 npc_beauty_pool.id
     */
    private Integer poolId;

    /**
     * 基础样式ID
     */
    private Integer styleId;

    private Integer sortOrder;

}
