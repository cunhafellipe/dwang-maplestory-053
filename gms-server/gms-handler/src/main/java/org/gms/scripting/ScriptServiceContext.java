package org.gms.scripting;

import jakarta.annotation.PostConstruct;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.gms.net.server.services.task.channel.EventService;
import org.gms.property.ServiceProperty;
import org.gms.server.achievement.AchievementService;
import org.gms.service.*;
import org.springframework.stereotype.Component;

/**
 * 聚合所有提供给 JS 脚本及脚本管理器使用的 Spring Service / Property 容器
 * 既支持 Spring 依赖注入，也支持非单例/非 Spring 管理类通过静态方法调用。
 *
 * @author dwang
 * @version 1.1
 * @since 2026/8/12 16:16
 */
@Component
@Getter
@RequiredArgsConstructor // 自动生成包含所有 final 字段的构造函数
public class ScriptServiceContext {

    private static ScriptServiceContext instance;

    // 新增 Bean 只需要在这里加一行 final 即可，无需改动构造函数！
    private final NpcCraftService craftService;
    private final GachaponService gachaponService;
    private final AchievementService achievementService;
    private final ServiceProperty serviceProperty;
    private final EventConfigDataService eventConfigDataService;
    private final NpcBeautyService npcBeautyService;
    private final NpcFuncService npcFuncService;



    @PostConstruct
    public void init() {
        ScriptServiceContext.instance = this;
    }

    public static ScriptServiceContext getInstance() {
        return instance;
    }

    public static ServiceProperty getStaticServiceProperty() {
        return instance != null ? instance.serviceProperty : null;
    }
}