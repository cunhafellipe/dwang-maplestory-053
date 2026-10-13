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
 * 美容美发/整容/美瞳/皮肤主分类表 实体类。
 *
 * @author 99605
 * @since 2026-10-13
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table("npc_beauty_cat")
public class NpcBeautyCatDO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Id(keyType = KeyType.Auto)
    private Integer id;

    /**
     * 菜单显示顺序 (#L0#, #L1#...)
     */
    private Integer menuIndex;

    /**
     * 中文分类名称
     */
    private String categoryName;

    /**
     * 核心类型
     */
    private String beautyType;

    /**
     * 服务模式
     */
    private String serviceMode;

    /**
     * 0: VIP自选, 1: 普通随机
     */
    private Boolean isRandom;

    /**
     * 台词模板 ID
     */
    private Integer templateId;

    /**
     * 二级菜单/预览框提示文本
     */
    private String promptText;

    /**
     * 操作前的警告文本
     */
    private String warningText;

    /**
     * 开关: 1=启用, 0=停用
     */
    private Boolean isActive;

}
