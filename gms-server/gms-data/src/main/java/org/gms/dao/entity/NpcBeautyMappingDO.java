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
 * NPC与美容池映射表 实体类。
 *
 * @author 99605
 * @since 2026-10-13
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table("npc_beauty_mapping")
public class NpcBeautyMappingDO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Id(keyType = KeyType.Auto)
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
     * 开关: 1=启用, 0=禁用
     */
    private Boolean isActive;

}
