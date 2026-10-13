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
 * 美容独立资源池 实体类。
 *
 * @author 99605
 * @since 2026-10-13
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table("npc_beauty_pool")
public class NpcBeautyPoolDO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Id(keyType = KeyType.Auto)
    private Integer id;

    /**
     * 资源池标识
     */
    private String poolName;

    /**
     * 关联 npc_beauty_cat.id 外键
     */
    private Integer categoryId;

    /**
     * 适用性别: 0=男, 1=女, -1=通用
     */
    private Integer gender;

    /**
     * 开关: 1=启用, 0=停用
     */
    private Boolean isActive;

}
