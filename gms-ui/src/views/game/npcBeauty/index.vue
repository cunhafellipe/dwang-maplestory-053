<template>
  <div class="container">
    <Breadcrumb />
    <a-card
      class="general-card"
      title="NPC美容 (剪发 / 染发 / 整容 / 美瞳 / 皮肤)"
    >
      <!-- 头部搜索过滤栏 -->
      <a-row>
        <a-col>
          <a-input-number
            v-model="beautyFilter.funcId"
            placeholder="功能 ID"
            @keydown.enter="loadClick"
          />
          <a-input-number
            v-model="beautyFilter.npcId"
            placeholder="NPC ID"
            @keydown.enter="loadClick"
          />
          <a-input
            v-model="beautyFilter.npcName"
            placeholder="NPC 名称"
            @keydown.enter="loadClick"
          />
          <a-space style="margin-left: 8px">
            <a-button type="primary" status="success" @click="loadClick">
              搜索
            </a-button>
            <a-button @click="resetClick">重置</a-button>
            <a-button type="outline" @click="openPoolManager">
              美容资源池管理
            </a-button>
            <a-button type="outline" @click="openStyleManager">
              样式管理
            </a-button>
          </a-space>
        </a-col>
      </a-row>

      <!-- 1. 主列表：美容 NPC 列表 -->
      <a-table
        v-show="detailNpcId <= 0"
        row-key="npcId"
        :loading="loading"
        :data="beautyList"
        column-resizable
        :pagination="false"
        :bordered="{ cell: true }"
        style="margin-top: 16px"
      >
        <template #columns>
          <a-table-column
            title="功能 ID"
            data-index="funcId"
            :width="100"
            align="center"
          >
            <template #cell="{ record }">
              {{ record.funcId ?? '-' }}
            </template>
          </a-table-column>
          <a-table-column
            title="NPC ID"
            data-index="npcId"
            :width="100"
            align="center"
          />
          <a-table-column
            title="NPC 名称"
            data-index="npcName"
            :width="160"
            align="center"
          />
          <a-table-column
            title="出没地图"
            data-index="mapName"
            :width="200"
            align="center"
            :cell-style="{ whiteSpace: 'pre-line' }"
          />
          <a-table-column title="绑定池数" :width="100" align="center">
            <template #cell="{ record }">
              <a-tag :color="record.poolCount > 0 ? 'arcoblue' : 'gray'">
                {{ record.poolCount ?? 0 }}
              </a-tag>
            </template>
          </a-table-column>
          <a-table-column title="业务登记" :width="110" align="center">
            <template #cell="{ record }">
              <a-tag :color="record.registered ? 'green' : 'orange'">
                {{ record.registered ? '已登记' : '仅绑定表' }}
              </a-tag>
            </template>
          </a-table-column>
          <a-table-column
            title="NPC 图片"
            data-index="npcId"
            :width="100"
            align="center"
          >
            <template #cell="{ record }">
              <img
                :src="getIconUrl('npc', record.npcId)"
                alt="NPC Icon"
                @error="hideBrokenIcon"
              />
            </template>
          </a-table-column>
          <a-table-column
            title="操作"
            :width="120"
            fixed="right"
            align="center"
          >
            <template #cell="{ record }">
              <a-button
                type="text"
                size="mini"
                @click="showDetailClick(record.npcId)"
              >
                查看配置
              </a-button>
            </template>
          </a-table-column>
        </template>
      </a-table>

      <!-- 2. 详情：台词 / 主分类 / 资源池 / 绑定关系与样式明细 -->
      <div v-if="detailNpcId > 0" style="margin-top: 16px">
        <a-space style="margin-bottom: 12px">
          <a-button size="small" @click="backToList">← 返回列表</a-button>
          <span>
            当前 NPC：<b>{{ detail.npcName }}</b> (ID: {{ detail.npcId }})
          </span>
          <a-tag v-if="detail.mapName" color="arcoblue">{{
            detail.mapName
          }}</a-tag>
        </a-space>

        <a-spin :loading="detailLoading" style="width: 100%">
          <!-- 2.1 NPC 台词 -->
          <a-card
            title="NPC 对话台词 (npc_dialog - beauty)"
            size="small"
            style="margin-bottom: 16px"
          >
            <template #extra>
              <a-button
                type="primary"
                status="success"
                size="small"
                @click="handleAddDialog"
              >
                新增台词
              </a-button>
            </template>

            <a-empty
              v-if="!detail.dialogs || detail.dialogs.length === 0"
              description="该 NPC 暂未配置专属台词 (将使用 npc_id = 0 的全局兜底台词)"
            />
            <a-table
              v-else
              :data="detail.dialogs"
              row-key="id"
              :pagination="false"
              bordered
              size="small"
            >
              <template #columns>
                <a-table-column
                  title="ID"
                  data-index="id"
                  :width="80"
                  align="center"
                />
                <a-table-column
                  title="Dialog Key (类型/标识)"
                  data-index="dialogKey"
                  :width="220"
                />
                <a-table-column title="台词文本 (Text)" data-index="dialogText">
                  <template #cell="{ record }">
                    <a-tag color="arcoblue">{{ record.dialogText }}</a-tag>
                  </template>
                </a-table-column>
                <a-table-column title="操作" :width="140" align="center">
                  <template #cell="{ record }">
                    <a-space>
                      <a-button
                        type="text"
                        size="mini"
                        @click="handleEditDialog(record)"
                      >
                        编辑
                      </a-button>
                      <a-popconfirm
                        content="确定要删除这条台词吗？"
                        @ok="handleDeleteDialog(record)"
                      >
                        <a-button type="text" status="danger" size="mini"
                          >删除</a-button
                        >
                      </a-popconfirm>
                    </a-space>
                  </template>
                </a-table-column>
              </template>
            </a-table>
          </a-card>
          <!-- 2.2 美容主分类 (只读) -->
          <a-card
            title="美容主分类表 (npc_beauty_cat) - 只读展示"
            size="small"
            style="margin-bottom: 16px"
          >
            <a-table
              :data="detail.categories || []"
              row-key="id"
              :pagination="false"
              bordered
              size="small"
            >
              <template #columns>
                <a-table-column
                  title="ID"
                  data-index="id"
                  :width="70"
                  align="center"
                />
                <a-table-column
                  title="Menu"
                  data-index="menuIndex"
                  :width="80"
                  align="center"
                />
                <a-table-column
                  title="分类名称"
                  data-index="categoryName"
                  :width="200"
                />
                <a-table-column
                  title="核心类型"
                  data-index="beautyType"
                  :width="100"
                  align="center"
                >
                  <template #cell="{ record }">
                    <a-tag :color="beautyTypeColor(record.beautyType)">{{
                      record.beautyType
                    }}</a-tag>
                  </template>
                </a-table-column>
                <a-table-column
                  title="服务模式"
                  data-index="serviceMode"
                  :width="140"
                  align="center"
                />
                <a-table-column title="随机/VIP" :width="100" align="center">
                  <template #cell="{ record }">
                    <a-tag :color="record.isRandom ? 'orange' : 'green'">
                      {{ record.isRandom ? '普通随机' : 'VIP自选' }}
                    </a-tag>
                  </template>
                </a-table-column>
                <a-table-column
                  title="模板ID"
                  data-index="templateId"
                  :width="90"
                  align="center"
                />
                <a-table-column
                  title="提示文本"
                  data-index="promptText"
                  :width="260"
                />
                <a-table-column
                  title="警告文本"
                  data-index="warningText"
                  :width="220"
                />
                <a-table-column title="开关" :width="90" align="center">
                  <template #cell="{ record }">
                    <a-tag :color="record.isActive ? 'green' : 'red'">
                      {{ record.isActive ? '启用' : '停用' }}
                    </a-tag>
                  </template>
                </a-table-column>
              </template>
            </a-table>
          </a-card>

          <!-- 2.3 NPC 绑定关系 (资源池本身的增删改在列表页的「美容资源池管理」中维护) -->
          <a-card
            title="NPC 绑定关系 (npc_beauty_mapping) - 只做绑定与解绑"
            size="small"
          >
            <template #extra>
              <a-button
                type="primary"
                status="success"
                size="small"
                @click="addMappingClick"
              >
                新增绑定
              </a-button>
            </template>

            <a-empty
              v-if="!detail.mappings || detail.mappings.length === 0"
              description="该 NPC 暂未绑定任何美容池"
            />

            <a-tabs v-else type="card-gutter">
              <a-tab-pane
                v-for="m in detail.mappings"
                :key="m.id"
                :title="mappingTabTitle(m)"
              >
                <a-space direction="vertical" fill style="margin-bottom: 12px">
                  <a-space wrap>
                    <a-button
                      type="primary"
                      size="mini"
                      @click="editMappingClick(m)"
                    >
                      编辑绑定
                    </a-button>
                    <a-popconfirm
                      content="确定删除该绑定吗？(不会删除资源池与其样式明细)"
                      @ok="removeMappingClick(m)"
                    >
                      <a-button type="primary" status="danger" size="mini"
                        >删除绑定</a-button
                      >
                    </a-popconfirm>
                  </a-space>
                  <span style="color: #86909c">
                    样式明细 (npc_beauty_pool_item)
                    请在列表页的「美容资源池管理」中维护，此处仅展示当前绑定资源池的样式。
                  </span>

                  <a-space wrap>
                    <span>
                      <b>会员卡/道具：</b>
                      <a-tag color="orange">{{ m.couponItemId }}</a-tag>
                      <img
                        v-if="m.couponItemId"
                        :src="getIconUrl('item', m.couponItemId)"
                        style="
                          width: 24px;
                          vertical-align: middle;
                          margin-left: 4px;
                        "
                        alt=""
                        @error="hideBrokenIcon"
                      />
                    </span>
                    <a-tag color="blue">类型: {{ m.beautyType || '-' }}</a-tag>
                    <a-tag color="purple"
                      >模式: {{ m.serviceMode || '-' }}</a-tag
                    >
                    <a-tag :color="genderColor(m.gender)"
                      >性别: {{ genderText(m.gender) }}</a-tag
                    >
                    <a-tag>排序: {{ m.sortOrder ?? 0 }}</a-tag>
                    <a-tag :color="m.isActive ? 'green' : 'red'">
                      开关: {{ m.isActive ? '启用' : '停用' }}
                    </a-tag>
                    <a-tag color="gray">资源池ID: {{ m.poolId }}</a-tag>
                  </a-space>
                </a-space>

                <a-table
                  :data="m.items || []"
                  :pagination="false"
                  row-key="id"
                  bordered
                  size="small"
                >
                  <template #columns>
                    <a-table-column title="图标" :width="70" align="center">
                      <template #cell="{ record }">
                        <img
                          :src="getIconUrl('item', record.styleId)"
                          alt="style icon"
                          @error="hideBrokenIcon"
                        />
                      </template>
                    </a-table-column>
                    <a-table-column
                      title="明细 ID"
                      data-index="id"
                      :width="100"
                      align="center"
                    />
                    <a-table-column
                      title="样式 ID"
                      data-index="styleId"
                      :width="140"
                      align="center"
                    />
                    <a-table-column
                      title="名称"
                      data-index="styleName"
                      :width="200"
                    >
                      <template #cell="{ record }">
                        {{ record.styleName || '-' }}
                      </template>
                    </a-table-column>
                    <a-table-column
                      title="排序"
                      data-index="sortOrder"
                      :width="100"
                      align="center"
                    />
                  </template>
                </a-table>
              </a-tab-pane>
            </a-tabs>
          </a-card>
        </a-spin>
      </div>

      <!-- 分页组件 (仅在主列表模式时生效) -->
      <a-pagination
        v-show="detailNpcId <= 0"
        style="margin-top: 20px"
        :total="total"
        :page-size="beautyFilter.pageSize"
        :current="beautyFilter.pageNo"
        show-total
        show-jumper
        show-page-size
        :page-size-options="[10, 20, 35, 70]"
        @change="pageChange"
        @page-size-change="pageSizeChange"
      />
    </a-card>

    <!-- 绑定关系新增/编辑 -->
    <mapping-form ref="mappingFormRef" @load-data="loadDetail" />
    <!-- 美容资源池管理 (npc_beauty_pool / npc_beauty_pool_item), 在列表页维护 -->
    <pool-manager ref="poolManagerRef" @load-data="refreshDetailIfOpened" />
    <!-- 样式管理: 053 wz 全部发型/脸型 + 被哪些池引用 + 批量加入池 -->
    <style-manager ref="styleManagerRef" @load-data="refreshDetailIfOpened" />

    <!-- 台词新增/编辑弹窗 -->
    <a-modal
      v-model:visible="dialogModalVisible"
      :title="isEditDialog ? '编辑 NPC 台词' : '新增 NPC 台词'"
      @before-ok="handleSaveDialog"
      @cancel="dialogModalVisible = false"
    >
      <a-form :model="dialogForm">
        <a-form-item field="dialogKey" label="Dialog Key" required>
          <a-input
            v-model="dialogForm.dialogKey"
            placeholder="请输入台词 Key，如: beauty_start / beauty_success"
            :disabled="isEditDialog"
          />
        </a-form-item>
        <a-form-item field="dialogText" label="台词文本" required>
          <a-textarea
            v-model="dialogForm.dialogText"
            placeholder="请输入 NPC 的具体对话内容"
            :auto-size="{ minRows: 3, maxRows: 6 }"
          />
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>

<script lang="ts" setup>
  import { ref } from 'vue';
  import useLoading from '@/hooks/loading';
  import { Message } from '@arco-design/web-vue';
  import { getIconUrl } from '@/utils/mapleStoryAPI';
  import {
    getBeautyList,
    getBeautyDetail,
    saveDialog,
    deleteDialog,
    deleteMapping,
    getBeautyFilter,
    BeautySearchRtnDTO,
    NpcBeautyDetail,
    NpcBeautyMappingForm,
    NpcDialogForm,
  } from '@/api/npcBeauty';
  import MappingForm from '@/views/game/npcBeauty/mappingForm.vue';
  import PoolManager from '@/views/game/npcBeauty/poolManager.vue';
  import StyleManager from '@/views/game/npcBeauty/styleManager.vue';

  const { loading, setLoading } = useLoading(false);
  const detailLoading = ref(false);

  // 详情模式: <= 0 表示列表模式
  const detailNpcId = ref<number>(-1);
  const total = ref<number>(0);

  const beautyFilter = ref<getBeautyFilter>({
    pageNo: 1,
    pageSize: 20,
    funcId: undefined,
    npcId: undefined,
    npcName: undefined,
  });

  const beautyList = ref<BeautySearchRtnDTO[]>([]);
  const detail = ref<NpcBeautyDetail>({
    npcId: 0,
    categories: [],
    pools: [],
    mappings: [],
    dialogs: [],
  });

  // ===================== 列表 =====================
  const loadBeautyList = async () => {
    setLoading(true);
    try {
      detailNpcId.value = -1;
      const { data } = await getBeautyList(beautyFilter.value);
      beautyList.value = data.records;
      total.value = data.totalRow;
    } catch (err: any) {
      Message.error(err.message || '获取 NPC 美容列表失败');
    } finally {
      setLoading(false);
    }
  };
  loadBeautyList();

  const loadClick = () => {
    beautyFilter.value.pageNo = 1;
    loadBeautyList();
  };

  const resetClick = () => {
    beautyFilter.value = {
      pageNo: 1,
      pageSize: 20,
      funcId: undefined,
      npcId: undefined,
      npcName: undefined,
    };
    loadBeautyList();
  };

  const pageChange = (page: number) => {
    beautyFilter.value.pageNo = page;
    loadBeautyList();
  };

  const pageSizeChange = (size: number) => {
    beautyFilter.value.pageNo = 1;
    beautyFilter.value.pageSize = size;
    loadBeautyList();
  };

  // ===================== 详情 =====================
  const loadDetail = async () => {
    if (detailNpcId.value <= 0) return;
    detailLoading.value = true;
    try {
      const { data } = await getBeautyDetail(detailNpcId.value);
      detail.value = data || {};
    } catch (err: any) {
      Message.error(err.message || '获取美容配置详情失败');
    } finally {
      detailLoading.value = false;
    }
  };

  const showDetailClick = async (npcId: number) => {
    detailNpcId.value = npcId;
    await loadDetail();
  };

  const backToList = () => {
    detailNpcId.value = -1;
    loadBeautyList();
  };

  // ===================== 台词 =====================
  const dialogModalVisible = ref(false);
  const isEditDialog = ref(false);
  const dialogForm = ref<NpcDialogForm>({
    id: undefined,
    npcId: 0,
    dialogType: 'beauty',
    templateId: 2,
    dialogKey: '',
    dialogText: '',
  });

  const handleAddDialog = () => {
    isEditDialog.value = false;
    dialogForm.value = {
      id: undefined,
      npcId: detailNpcId.value,
      dialogType: 'beauty',
      templateId: 2,
      dialogKey: '',
      dialogText: '',
    };
    dialogModalVisible.value = true;
  };

  const handleEditDialog = (record: NpcDialogForm) => {
    isEditDialog.value = true;
    dialogForm.value = {
      id: record.id,
      npcId: record.npcId || detailNpcId.value,
      dialogType: record.dialogType || 'beauty',
      templateId: record.templateId || 2,
      dialogKey: record.dialogKey,
      dialogText: record.dialogText,
    };
    dialogModalVisible.value = true;
  };

  const handleSaveDialog = async (done: (closed: boolean) => void) => {
    if (!dialogForm.value.dialogKey) {
      Message.warning('请输入 Dialog Key');
      done(false);
      return;
    }
    try {
      await saveDialog(dialogForm.value);
      Message.success('保存成功！');
      done(true);
      await loadDetail();
    } catch (err: any) {
      Message.error(err.message || '保存失败');
      done(false);
    }
  };

  const handleDeleteDialog = async (record: NpcDialogForm) => {
    try {
      await deleteDialog({
        id: record.id,
        npcId: record.npcId || detailNpcId.value,
        dialogKey: record.dialogKey,
      } as NpcDialogForm);
      Message.success('删除成功！');
      await loadDetail();
    } catch (err: any) {
      Message.error(err.message || '删除失败');
    }
  };

  // ===================== 绑定关系 =====================
  const mappingFormRef = ref();
  const addMappingClick = () => {
    mappingFormRef.value.initAdd(detailNpcId.value, detail.value.pools || []);
  };
  const editMappingClick = (m: NpcBeautyMappingForm) => {
    mappingFormRef.value.initEdit(m, detail.value.pools || []);
  };
  const removeMappingClick = async (m: NpcBeautyMappingForm) => {
    try {
      await deleteMapping({ id: m.id, npcId: m.npcId } as NpcBeautyMappingForm);
      Message.success('删除成功！');
      await loadDetail();
    } catch (err: any) {
      Message.error(err.message || '删除失败');
    }
  };

  // ===================== 资源池管理 (在列表页弹窗中维护, 详情页只做绑定/解绑) =====================
  const poolManagerRef = ref();
  const openPoolManager = () => {
    poolManagerRef.value.initManager();
  };
  // ===================== 样式管理 (053 wz 全部发型/脸型, 查看引用 + 批量加入池) =====================
  const styleManagerRef = ref();
  const openStyleManager = () => {
    styleManagerRef.value.initManager();
  };
  // 资源池/样式明细改动后, 已打开的详情需要刷新展示
  const refreshDetailIfOpened = () => {
    if (detailNpcId.value > 0) {
      loadDetail();
    }
  };

  // ===================== 展示辅助 =====================
  const mappingTabTitle = (m: NpcBeautyMappingForm) =>
    `${m.poolName || `池 ${m.poolId}`} · ${m.categoryName || '-'} (${
      m.items ? m.items.length : 0
    })`;

  const genderText = (gender?: number) => {
    if (gender === -1) return '通用';
    if (gender === 1) return '女';
    if (gender === 0) return '男';
    return '-';
  };

  const genderColor = (gender?: number) => {
    if (gender === -1) return 'gray';
    if (gender === 1) return 'pink';
    return 'blue';
  };

  const beautyTypeColor = (beautyType?: string) => {
    if (beautyType === 'HAIR') return 'arcoblue';
    if (beautyType === 'FACE') return 'purple';
    if (beautyType === 'SKIN') return 'green';
    return 'gray';
  };

  const hideBrokenIcon = (e: Event) => {
    const target = e.target as HTMLImageElement;
    if (target) {
      target.style.visibility = 'hidden';
    }
  };
</script>

<script lang="ts">
  export default {
    name: 'NpcBeauty',
  };
</script>

<style lang="less" scoped>
  .container {
    padding: 0 20px 20px 20px;
  }
  :deep(.arco-card-body, .arco-row) {
    width: 100%;
  }
  .arco-input-wrapper,
  .arco-input-number {
    margin-right: 0;
    margin-bottom: 5px;
    width: 100%;
  }
  @media (min-width: 500px) {
    .arco-input-wrapper,
    .arco-input-number {
      margin-right: 8px;
      width: 140px;
    }
  }
</style>
