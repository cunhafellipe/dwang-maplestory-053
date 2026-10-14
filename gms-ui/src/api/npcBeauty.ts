import axios from 'axios';

/** 美容类型: HAIR=发型, FACE=脸型(含美瞳), SKIN=皮肤 */
export type BeautyType = 'HAIR' | 'FACE' | 'SKIN';

/** 列表项 (对应 Java: BeautySearchRtnDTO) */
export interface BeautySearchRtnDTO {
  funcId?: number;
  npcId?: number;
  npcName?: string;
  mapName?: string;
  poolCount?: number;
  registered?: boolean;
}

/** 列表查询条件 (对应 Java: BeautySearchReqDTO) */
export interface getBeautyFilter {
  pageNo?: number;
  pageSize?: number;
  onlyTotal?: boolean;
  notPage?: boolean;
  funcId?: number;
  npcId?: number;
  npcName?: string;
}

/** 样式明细 (对应 Java: BeautyPoolItemDTO) */
export interface NpcBeautyPoolItemForm {
  id?: number;
  poolId?: number;
  styleId?: number;
  sortOrder?: number;
  /** 只读: 样式中文名 (发型/脸型) */
  styleName?: string;
  /** 只读: 资源池对应的美容类型 HAIR / FACE / SKIN */
  beautyType?: string;
}

/** 样式明细批量保存 (对应 Java: BeautyPoolItemBatchDTO) */
export interface NpcBeautyPoolItemBatchForm {
  poolId: number;
  styleIds: number[];
}

/** 资源池 (对应 Java: BeautyPoolDTO) */
export interface NpcBeautyPoolForm {
  id?: number;
  poolName?: string;
  categoryId?: number;
  gender?: number;
  isActive?: boolean;
  categoryName?: string;
  beautyType?: string;
  serviceMode?: string;
  itemCount?: number;
}

/** NPC 与资源池绑定关系 (对应 Java: BeautyMappingDTO) */
export interface NpcBeautyMappingForm {
  id?: number;
  npcId?: number;
  poolId?: number;
  couponItemId?: number;
  sortOrder?: number;
  isActive?: boolean;
  npcName?: string;
  poolName?: string;
  categoryId?: number;
  categoryName?: string;
  beautyType?: string;
  serviceMode?: string;
  gender?: number;
  templateId?: number;
  isRandom?: boolean;
  itemCount?: number;
  items?: NpcBeautyPoolItemForm[];
}

/** 美容主分类 (对应 Java: NpcBeautyCatDO, 只读) */
export interface NpcBeautyCat {
  id?: number;
  menuIndex?: number;
  categoryName?: string;
  beautyType?: string;
  serviceMode?: string;
  isRandom?: boolean;
  templateId?: number;
  promptText?: string;
  warningText?: string;
  isActive?: boolean;
}

/** NPC 台词 (对应 Java: NpcDialog) */
export interface NpcDialogForm {
  id?: number;
  npcId: number;
  templateId?: number;
  dialogType?: string;
  dialogKey: string;
  dialogText?: string;
}

/** Character.wz 基础样式 (对应 Java: BeautyWzStyleDTO) */
export interface BeautyWzStyle {
  styleId: number;
  beautyType?: string;
  gender?: number;
  /** 样式中文名 (发型/脸型) */
  styleName?: string;
  colorCount?: number;
  configured?: boolean;
}

/** 美容配置详情 (对应 Java: NpcBeautyDetailDTO) */
export interface NpcBeautyDetail {
  funcId?: number;
  npcId?: number;
  npcName?: string;
  mapName?: string;
  categories?: NpcBeautyCat[];
  pools?: NpcBeautyPoolForm[];
  mappings?: NpcBeautyMappingForm[];
  dialogs?: NpcDialogForm[];
}

/** 引用某个样式的资源池 (对应 Java: BeautyPoolRefDTO) */
export interface BeautyPoolRef {
  poolId?: number;
  poolName?: string;
  categoryId?: number;
  categoryName?: string;
  gender?: number;
}

/** 样式总览项 (对应 Java: BeautyStyleOverviewDTO) */
export interface BeautyStyleOverview {
  styleId: number;
  styleName?: string;
  beautyType?: string;
  gender?: number;
  colorCount?: number;
  /** 被多少个资源池引用 (0 = 没有任何池在用) */
  refCount?: number;
  pools?: BeautyPoolRef[];
}

/** 批量把样式加入资源池 (对应 Java: BeautyStyleBatchAddDTO) */
export interface NpcBeautyStyleBatchAddForm {
  styleIds: number[];
  poolIds: number[];
}

/** 1. 分页获取美容 NPC 列表 */
export function getBeautyList(data: getBeautyFilter) {
  return axios.post('/api/npc-beauty/v1/getBeautyList', data);
}

/** 2. 获取 NPC 美容配置详情 (分类 / 资源池 / 绑定 / 台词) */
export function getBeautyDetail(npcId: number) {
  return axios.get(`/api/npc-beauty/v1/detail/${npcId}`);
}

/** 3. 获取美容主分类列表 (只读) */
export function getBeautyCategories() {
  return axios.get('/api/npc-beauty/v1/categories');
}

/** 4. 获取全量美容资源池列表 */
export function getBeautyPools() {
  return axios.get('/api/npc-beauty/v1/pools');
}

/** 4.1 获取指定资源池的样式明细 (含发型/脸型中文名) */
export function getPoolItems(poolId: number) {
  return axios.get(`/api/npc-beauty/v1/poolItems/${poolId}`);
}

/** 4.2 样式总览: wz 全部样式 + 被哪些池引用 */
export function getStyleOverview(params: {
  beautyType?: string;
  gender?: number;
}) {
  return axios.get('/api/npc-beauty/v1/styleOverview', { params });
}

/** 4.3 批量把样式加入资源池 */
export function addStylesToPools(data: NpcBeautyStyleBatchAddForm) {
  return axios.post('/api/npc-beauty/v1/addStylesToPools', data);
}

/** 5. 读取 Character.wz 发型/脸型基础样式 */
export function getWzStyles(params: {
  beautyType?: string;
  gender?: number;
  poolId?: number;
}) {
  return axios.get('/api/npc-beauty/v1/wzStyles', { params });
}

/** 6. 获取 NPC 台词 Map */
export function getBeautyDialogsMap(npcId: number, dialogType = 'beauty') {
  return axios.get(`/api/npc-beauty/v1/dialogsMap/${npcId}`, {
    params: { dialogType },
  });
}

/** 7. 获取 NPC 台词 List */
export function getBeautyDialogs(npcId: number, dialogType = 'beauty') {
  return axios.get(`/api/npc-beauty/v1/dialogs/${npcId}`, {
    params: { dialogType },
  });
}

/** 8. 新增或修改 NPC 台词 */
export function saveDialog(data: NpcDialogForm) {
  return axios.post('/api/npc-beauty/v1/saveDialog', data);
}

/** 9. 删除 NPC 台词 */
export function deleteDialog(data: NpcDialogForm) {
  return axios.post('/api/npc-beauty/v1/deleteDialog', data);
}

/** 10. 新增或修改绑定关系 (会员卡 / 排序 / 开关) */
export function saveMapping(data: NpcBeautyMappingForm) {
  return axios.post('/api/npc-beauty/v1/saveMapping', data);
}

/** 11. 删除绑定关系 */
export function deleteMapping(data: NpcBeautyMappingForm) {
  return axios.post('/api/npc-beauty/v1/deleteMapping', data);
}

/** 12. 新增或修改资源池 */
export function savePool(data: NpcBeautyPoolForm) {
  return axios.post('/api/npc-beauty/v1/savePool', data);
}

/** 13. 删除资源池 (级联删除样式明细与绑定) */
export function deletePool(data: NpcBeautyPoolForm) {
  return axios.post('/api/npc-beauty/v1/deletePool', data);
}

/** 14. 新增或修改单条样式明细 */
export function savePoolItem(data: NpcBeautyPoolItemForm) {
  return axios.post('/api/npc-beauty/v1/savePoolItem', data);
}

/** 15. 整池覆盖式保存样式明细 (顺序即 sort_order) */
export function savePoolItems(data: NpcBeautyPoolItemBatchForm) {
  return axios.post('/api/npc-beauty/v1/savePoolItems', data);
}

/** 16. 删除单条样式明细 */
export function deletePoolItem(data: NpcBeautyPoolItemForm) {
  return axios.post('/api/npc-beauty/v1/deletePoolItem', data);
}
