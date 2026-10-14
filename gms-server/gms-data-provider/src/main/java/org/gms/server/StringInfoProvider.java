package org.gms.server;

import lombok.Getter;
import org.gms.provider.*;
import org.gms.provider.wz.WzFiles;
import org.gms.util.Pair;
import org.gms.util.RequireUtil;

import java.util.*;

/**
 * 提供WZ的String信息
 *
 * @author dwang
 * @version 1.0
 * @since 2026/8/10 11:42
 */

public class StringInfoProvider {
    @Getter
    private final static DataProvider stringDataWZ = DataProviderFactory.getDataProvider(WzFiles.STRING);

    @Getter
    private static final Data mobStringData = stringDataWZ.getData("Mob.img");
    @Getter
    private static final Data npcStringData = stringDataWZ.getData("Npc.img");
    @Getter
    private static final Data mapStringData = stringDataWZ.getData("Map.img");
    @Getter
    private static final Data skillStringData = stringDataWZ.getData("Skill.img");
    @Getter
    private static final Data cashStringData = stringDataWZ.getData("Cash.img");
    @Getter
    private static final Data consumeStringData = stringDataWZ.getData("Consume.img");
    @Getter
    private static final Data eqpStringData = stringDataWZ.getData("Eqp.img").getChildByPath("Eqp");
    @Getter
    private static final Data etcStringData = stringDataWZ.getData("Etc.img").getChildByPath("Etc");
    @Getter
    private static final Data insStringData = stringDataWZ.getData("Ins.img");
    @Getter
    private static final Data petStringData = stringDataWZ.getData("Pet.img");




    private final static DataProvider questDataWZ = DataProviderFactory.getDataProvider(WzFiles.QUEST);
    private static final Data questInfoData = questDataWZ.getData("QuestInfo.img");

    @Getter
    private static Map<Integer, String> npcNames = new HashMap<>();
    @Getter
    private static Map<Integer, String> skillNames = new HashMap<>();
    @Getter
    private static Map<Integer, String> mobNames = new HashMap<>();
    @Getter
    private static Map<Integer, String> mapNames = new HashMap<>();
    @Getter
    private static Map<String, String> bgmsNameAndMapName = new HashMap<>();

    /**
     * 美容(美发/整容)相关名字缓存：String.wz/Eqp.img/Eqp/{Hair|Face}/{styleId}/name
     * 只加载这两个分类, 其它装备分类不加载
     */
    @Getter
    private static Map<Integer, String> hairNames = new HashMap<>();
    @Getter
    private static Map<Integer, String> faceNames = new HashMap<>();

    /**
     * 发型/脸型名字是否已加载 (取名字时若未加载会自动补一次)
     */
    private static volatile boolean beautyStyleNameLoaded = false;


    private static final Map<Integer, String> questNames = new HashMap<>();

    @Getter
    private static final Map<Integer, List<MapStrInfo>> NPC_EXIST_MAP = new LinkedHashMap<>();
    @Getter
    private static final Map<Integer, List<MapStrInfo>> MOB_EXIST_MAP = new LinkedHashMap<>();

    static {
        // 美容(发型/脸型)名字数据量很小, 服务启动时一次性加载
        initBeautyStyleNames();
        initMapStr();
    }

    /**
     * 加载美容相关的发型 / 脸型中文名 (String.wz/Eqp.img/Eqp/{Hair|Face}/{id}/name)
     * 服务启动时调用; 取名字时若发现未加载也会自动补一次
     */
    public static void initBeautyStyleNames() {
        try {
            Data hairData = eqpStringData == null ? null : eqpStringData.getChildByPath("Hair");
            Data faceData = eqpStringData == null ? null : eqpStringData.getChildByPath("Face");
            // 先构建到局部变量再整体替换, 避免并发读到半成品
            Map<Integer, String> hair = hairData == null ? new HashMap<>() : buildParamName(hairData);
            Map<Integer, String> face = faceData == null ? new HashMap<>() : buildParamName(faceData);
            hairNames = hair;
            faceNames = face;
            beautyStyleNameLoaded = true;
        } catch (Exception e) {
            System.err.println("加载发型/脸型名字失败：" + e.getMessage());
        }
    }

    private static void ensureBeautyStyleNames() {
        if (!beautyStyleNameLoaded) {
            initBeautyStyleNames();
        }
    }

    /**
     * 取发型中文名, 取不到返回 null
     */
    public static String getHairName(int styleId) {
        ensureBeautyStyleNames();
        return hairNames.get(styleId);
    }

    /**
     * 取脸型中文名, 取不到返回 null
     */
    public static String getFaceName(int styleId) {
        ensureBeautyStyleNames();
        return faceNames.get(styleId);
    }

    /**
     * 按美容类型取发型/脸型中文名
     *
     * @param beautyType HAIR / FACE, 为空时按官方 ID 区间兜底推断
     */
    public static String getBeautyStyleName(String beautyType, Integer styleId) {
        if (styleId == null) {
            return null;
        }
        ensureBeautyStyleNames();
        if ("FACE".equalsIgnoreCase(beautyType)) {
            return faceNames.get(styleId);
        }
        if ("HAIR".equalsIgnoreCase(beautyType)) {
            return hairNames.get(styleId);
        }
        // 类型未知时按 ID 区间推断
        if (styleId >= 20000 && styleId <= 21999) {
            return faceNames.get(styleId);
        }
        if (styleId >= 30000 && styleId <= 31999) {
            return hairNames.get(styleId);
        }
        return null;
    }

    /**
     * 加载出没地图
     */
    /**
     * 加载出没地图信息并构建映射表 (lifeId -> 地图分布列表)
     */
    private static void initMapStr() {
        // 1. 先清空历史数据，防止重复调用 initMapStr 时数据叠加
        NPC_EXIST_MAP.clear();
        MOB_EXIST_MAP.clear();

        mobNames = buildParamName(mobStringData);
        npcNames = buildParamName(npcStringData);
        mapNames = buildMapName(mapStringData);

        // 技能名额外加载
        skillNames = buildParamName(skillStringData);


        DataProvider mapSource = DataProviderFactory.getDataProvider(WzFiles.MAP);
        DataDirectoryEntry root = mapSource.getRoot();

        for (DataDirectoryEntry objData : root.getSubdirectories()) {
            if (!"Map".contentEquals(objData.getName())) {
                continue;
            }

            // 遍历 Map/Map0, Map/Map1 等子目录
            for (DataDirectoryEntry mapFileDir : objData.getSubdirectories()) {
                if (!mapFileDir.getName().contains("Map")) {
                    continue;
                }

                List<DataFileEntry> files = mapFileDir.getFiles();
                for (DataFileEntry file : files) {
                    String path = objData.getName() + "/" + mapFileDir.getName() + "/" + file.getName();
                    Data mapData = mapSource.getData(path);
                    if (mapData == null) {
                        System.err.println("无法读取文件，跳过该地图：" + path);
                        continue; // 改为 continue，避免单文件错误导致整个引擎初始化终止
                    }

                    String fileName = file.getName();
                    int dotIndex = fileName.indexOf('.');
                    if (dotIndex == -1) {
                        continue;
                    }

                    int mapId;
                    try {
                        mapId = Integer.parseInt(fileName.substring(0, dotIndex));
                    } catch (NumberFormatException e) {
                        // 忽略非数字名称的 img 文件
                        continue;
                    }

                    String mapName = mapNames.get(mapId);
                    Data infoNode = mapData.getChildByPath("info");
                    String bgm = DataTool.getString(infoNode.getChildByPath("bgm"), "");
                    bgmsNameAndMapName.putIfAbsent(bgm, mapName);

                    Data lifeNode = mapData.getChildByPath("life");

                    if (lifeNode != null) {
                        for (Data life : lifeNode) {
                            String type = DataTool.getString(life.getChildByPath("type"), "");
                            String idStr = DataTool.getString(life.getChildByPath("id"), "");

                            if (idStr.isEmpty()) {
                                continue;
                            }

                            try {
                                int lifeId = Integer.parseInt(idStr);

                                if ("n".equalsIgnoreCase(type)) {
                                    String npcName = npcNames.getOrDefault(lifeId, "unknow");
                                    NPC_EXIST_MAP.computeIfAbsent(lifeId, k -> new ArrayList<>())
                                            .add(new MapStrInfo(lifeId, type, npcName, mapId, mapName));

                                } else if ("m".equalsIgnoreCase(type)) {
                                    String mobName = mobNames.getOrDefault(lifeId, "unknow");
                                    MOB_EXIST_MAP.computeIfAbsent(lifeId, k -> new ArrayList<>())
                                            .add(new MapStrInfo(lifeId, type, mobName, mapId, mapName));
                                }
                            } catch (NumberFormatException ignored) {
                                // 忽略非法 ID
                            }
                        }
                    }
                }
            }
        }
//        int size = bgms.size(); // 86 in GMS053
//        System.out.println("音乐有");
//        for (String bgm : bgms) {
//            System.out.println(bgm);
//        }

    }


    public static String getNPCName(int nid) {
        String name = npcNames.get(nid);
        if (RequireUtil.isEmpty(name)) {
            name = DataTool.getString(nid + "/name", npcStringData, "MISSINGNO");
            npcNames.put(nid, name);
        }
        return name;
    }


    public static String getQuestName(int qid) {
        String name = questNames.get(qid);
        if (RequireUtil.isEmpty(name)) {
            name = DataTool.getString(qid + "/name", questInfoData, "");
            questNames.put(qid, name);
        }
        return name;
    }

    public static String getMobName(int mid) {
        return mobNames.get(mid);
    }
    public static String getMapName(int mapId) {
        return mapNames.get(mapId);
    }

    /**
     * 按地图 ID 取 String.wz/Map.img 里的地图名，取不到返回 null。
     */
    public static String getMapNameById(int mapId) {
        String name = mapNames.get(mapId);
        if (RequireUtil.isEmpty(name) || "NO_NAME".equals(name)) {
            return null;
        }
        return name;
    }


    private static HashMap<Integer, String> buildMapName(Data data) {
        HashMap<Integer, String> paramMap = new HashMap<>();
        for (Data searchData : data.getChildren()) {
            for (Data child : searchData.getChildren()) {
                String imgIdName = child.getName();
                if (imgIdName == null || !imgIdName.matches("\\d+")) {
                    continue;
                }
                int imgId = Integer.parseInt(imgIdName);

                String name = DataTool.getString(child.getChildByPath("mapName"), "NO_NAME");
                paramMap.put(imgId, name);

            }

        }
        return paramMap;
    }


    /**
     * 生成ID和参数名对照
     *
     */
    private static Map<Integer, String> buildParamName(Data data) {
        HashMap<Integer, String> paramMap = new HashMap<>();
        for (Data searchData : data.getChildren()) {
            String imgIdName = searchData.getName();
            if (imgIdName == null || !imgIdName.matches("\\d+")) {
                continue;
            }
            int imgId = Integer.parseInt(imgIdName);

            String name = DataTool.getString(searchData.getChildByPath("name"), "NO_NAME");
            paramMap.put(imgId, name);
        }
        return paramMap;

    }

    public static String getNpcExistMapName(Integer npcId) {
        List<MapStrInfo> mapStrInfos = NPC_EXIST_MAP.get(npcId);
        StringBuilder stringBuilder = new StringBuilder();
        if (mapStrInfos == null || mapStrInfos.size() == 0) {
            return "当前版本不存在";
        }
        for (MapStrInfo mapStrInfo : mapStrInfos) {
            stringBuilder.append(mapStrInfo.mapName).append("(").append(mapStrInfo.mapId).append(")");
            stringBuilder.append("\n");
        }
        return stringBuilder.toString();
    }

    public static String getSkillName(int skillid) {
        Data data = skillStringData;
        StringBuilder skill = new StringBuilder();
        skill.append(skillid);
        if (skill.length() == 4) {
            skill.delete(0, 4);
            skill.append("000").append(skillid);
        }
        if (data.getChildByPath(skill.toString()) != null) {
            for (Data skilldata : data.getChildByPath(skill.toString()).getChildren()) {
                if (skilldata.getName().equals("name")) {
                    return DataTool.getString(skilldata, null);
                }
            }
        }

        return null;
    }

    public List<Pair<Integer, String>> getAllEtcItems() {

        List<Pair<Integer, String>> itemPairs = new ArrayList<>();
        Data itemsData;

        itemsData = StringInfoProvider.getEtcStringData();
        for (Data itemFolder : itemsData.getChildren()) {
            itemPairs.add(new Pair<>(Integer.parseInt(itemFolder.getName()), DataTool.getString("name", itemFolder, "NO-NAME")));
        }
        return itemPairs;
    }

    public static String getMobNameFromId(int id) {
        return mobNames.get(id);
    }

}
