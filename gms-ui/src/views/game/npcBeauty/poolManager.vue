<template>
  <a-modal
    v-model:visible="visible"
    :footer="false"
    :width="1300"
    title="美容资源池管理 (npc_beauty_pool / npc_beauty_pool_item)"
    @cancel="handleCancel"
  >
    <a-spin :loading="loading" style="width: 100%">
      <a-space wrap style="margin-bottom: 12px">
        <a-button
          type="primary"
          status="success"
          size="small"
          @click="addPoolClick"
        >
          新增资源池
        </a-button>
        <a-button size="small" @click="loadPools">刷新</a-button>
        <span style="color: #86909c">
          一般只新增不删除；删除资源池会级联删除其样式明细与 NPC 绑定关系
        </span>
      </a-space>

      <!-- 按类型 / 名称筛选资源池 -->
      <a-space wrap style="margin-bottom: 8px; margin-left: 10px">
        <a-select v-model="typeFilter" style="width: 160px">
          <a-option value="">全部类型</a-option>
          <a-option value="HAIR">HAIR (发型 / 染发)</a-option>
          <a-option value="FACE">FACE (整容 / 美瞳)</a-option>
          <a-option value="SKIN">SKIN (皮肤)</a-option>
        </a-select>
        <a-input
          v-model="poolKeyword"
          placeholder="按池名 / 分类名搜索"
          allow-clear
          style="width: 220px"
        />
        <a-button size="small" @click="resetFilter">重置筛选</a-button>
        <a-tag color="arcoblue">
          共 {{ filteredPools.length }} / {{ pools.length }} 个池
        </a-tag>
      </a-space>

      <a-table
        :data="filteredPools"
        row-key="id"
        :pagination="poolPagination"
        :row-class="rowClass"
        bordered
        size="small"
        @page-change="onPoolPageChange"
        @page-size-change="onPoolPageSizeChange"
      >
        <template #columns>
          <a-table-column
            title="ID"
            data-index="id"
            :width="70"
            align="center"
          />
          <a-table-column
            title="资源池标识"
            data-index="poolName"
            :width="200"
          />
          <a-table-column title="所属分类" :width="190">
            <template #cell="{ record }">
              {{ record.categoryName || '-' }}
              <span style="color: #86909c">({{ record.categoryId }})</span>
            </template>
          </a-table-column>
          <a-table-column
            title="类型"
            data-index="beautyType"
            :width="90"
            align="center"
          >
            <template #cell="{ record }">
              <a-tag :color="beautyTypeColor(record.beautyType)">
                {{ record.beautyType || '-' }}
              </a-tag>
            </template>
          </a-table-column>
          <a-table-column
            title="服务模式"
            data-index="serviceMode"
            :width="130"
            align="center"
          />
          <a-table-column title="性别" :width="80" align="center">
            <template #cell="{ record }">
              <a-tag :color="genderColor(record.gender)">
                {{ genderText(record.gender) }}
              </a-tag>
            </template>
          </a-table-column>
          <a-table-column title="明细" :width="80" align="center">
            <template #cell="{ record }">
              <a-tag :color="record.itemCount > 0 ? 'arcoblue' : 'gray'">
                {{ record.itemCount ?? 0 }}
              </a-tag>
            </template>
          </a-table-column>
          <a-table-column title="开关" :width="80" align="center">
            <template #cell="{ record }">
              <a-tag :color="record.isActive ? 'green' : 'red'">
                {{ record.isActive ? '启用' : '停用' }}
              </a-tag>
            </template>
          </a-table-column>
          <a-table-column
            title="操作"
            :width="200"
            fixed="right"
            align="center"
          >
            <template #cell="{ record }">
              <a-space>
                <a-button
                  type="text"
                  size="mini"
                  @click="showItemsClick(record)"
                >
                  样式明细
                </a-button>
                <a-button
                  type="text"
                  size="mini"
                  @click="editPoolClick(record)"
                >
                  编辑
                </a-button>
                <a-popconfirm
                  content="确定删除该资源池吗？其样式明细与 NPC 绑定关系将一并删除！"
                  @ok="removePoolClick(record)"
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

      <a-card
        v-if="currentPool"
        ref="itemsCardRef"
        size="small"
        style="margin-top: 16px"
        :title="`样式明细 - ${currentPool.poolName || ''} (${items.length})`"
      >
        <template #extra>
          <a-space>
            <a-button size="small" @click="addItemClick"
              >+ 新增单条样式</a-button
            >
            <a-button
              type="primary"
              status="success"
              size="small"
              @click="openPickerClick"
            >
              批量配置样式明细
            </a-button>
          </a-space>
        </template>

        <a-empty
          v-if="items.length === 0"
          description="该资源池还没有配置任何样式"
        />
        <a-table
          v-else
          :data="items"
          row-key="id"
          :pagination="false"
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
              :width="90"
              align="center"
            />
            <a-table-column
              title="样式 ID"
              data-index="styleId"
              :width="110"
              align="center"
            />
            <a-table-column title="名称" data-index="styleName" :width="220">
              <template #cell="{ record }">
                {{ record.styleName || '-' }}
              </template>
            </a-table-column>
            <a-table-column
              title="排序"
              data-index="sortOrder"
              :width="80"
              align="center"
            />
            <a-table-column title="操作" :width="140" align="center">
              <template #cell="{ record }">
                <a-space>
                  <a-button
                    type="text"
                    size="mini"
                    @click="editItemClick(record)"
                  >
                    编辑
                  </a-button>
                  <a-popconfirm
                    content="确定删除该样式明细吗？"
                    @ok="removeItemClick(record)"
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
      <a-empty
        v-else
        style="margin-top: 16px"
        description="点击上方资源池的「样式明细」查看 / 维护该池的样式配置"
      />

      <div style="text-align: right; margin-top: 16px">
        <a-button @click="handleCancel">关闭</a-button>
      </div>
    </a-spin>

    <!-- 资源池新增/编辑 -->
    <pool-form ref="poolFormRef" @load-data="onPoolSaved" />
    <!-- 单条样式明细新增/编辑 -->
    <pool-item-form ref="poolItemFormRef" @load-data="reloadItems" />
    <!-- 样式明细批量配置 (读取 Character.wz) -->
    <pool-item-picker ref="poolItemPickerRef" @load-data="reloadItems" />
  </a-modal>
</template>

<script lang="ts" setup>
  import { ref, reactive, computed, watch, nextTick } from 'vue';
  import useLoading from '@/hooks/loading';
  import { Message } from '@arco-design/web-vue';
  import { getIconUrl, hideBrokenIcon } from '@/utils/mapleStoryAPI';
  import {
    getBeautyPools,
    getBeautyCategories,
    getPoolItems,
    deletePool,
    deletePoolItem,
    NpcBeautyCat,
    NpcBeautyPoolForm,
    NpcBeautyPoolItemForm,
  } from '@/api/npcBeauty';
  import PoolForm from '@/views/game/npcBeauty/poolForm.vue';
  import PoolItemForm from '@/views/game/npcBeauty/poolItemForm.vue';
  import PoolItemPicker from '@/views/game/npcBeauty/poolItemPicker.vue';

  const { loading, setLoading } = useLoading(false);
  const visible = ref<boolean>(false);

  const pools = ref<NpcBeautyPoolForm[]>([]);
  const categories = ref<NpcBeautyCat[]>([]);
  const currentPool = ref<NpcBeautyPoolForm | null>(null);
  const items = ref<NpcBeautyPoolItemForm[]>([]);
  const itemsCardRef = ref();

  // 资源池列表分页: 一页 10 个, 免得下面的样式明细被顶到屏幕外
  const poolPagination = reactive({
    current: 1,
    pageSize: 10,
    showTotal: true,
    showPageSize: true,
    pageSizeOptions: [10, 20, 50],
  });

  const onPoolPageChange = (page: number) => {
    poolPagination.current = page;
  };

  const onPoolPageSizeChange = (size: number) => {
    poolPagination.pageSize = size;
    poolPagination.current = 1;
  };

  // 资源池筛选: 只按 HAIR / FACE / SKIN 看某一类
  const typeFilter = ref<string>('');
  const poolKeyword = ref<string>('');

  const filteredPools = computed(() => {
    let list = pools.value;
    if (typeFilter.value) {
      list = list.filter((pool) => pool.beautyType === typeFilter.value);
    }
    const text = poolKeyword.value.trim();
    if (text) {
      list = list.filter(
        (pool) =>
          (pool.poolName || '').includes(text) ||
          (pool.categoryName || '').includes(text)
      );
    }
    return list;
  });

  // 筛选条件一变就回到第 1 页, 免得停在一个空的页码上
  watch([typeFilter, poolKeyword], () => {
    poolPagination.current = 1;
  });

  const resetFilter = () => {
    typeFilter.value = '';
    poolKeyword.value = '';
  };

  const emit = defineEmits(['loadData']);

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

  const rowClass = (record: NpcBeautyPoolForm) =>
    record.id === currentPool.value?.id ? 'current-pool-row' : '';

  // 资源池列表 (同时把当前选中池刷新为最新数据)
  const loadPools = async () => {
    setLoading(true);
    try {
      const { data } = await getBeautyPools();
      pools.value = data || [];
      if (currentPool.value?.id) {
        const latest = pools.value.find(
          (pool) => pool.id === currentPool.value?.id
        );
        currentPool.value = latest || null;
        if (!latest) {
          items.value = [];
        }
      }
    } catch (err: any) {
      Message.error(err.message || '获取美容资源池失败');
    } finally {
      setLoading(false);
    }
  };

  const loadCategories = async () => {
    try {
      const { data } = await getBeautyCategories();
      categories.value = data || [];
    } catch (err: any) {
      Message.error(err.message || '获取美容分类失败');
    }
  };

  // 当前选中池的样式明细
  const loadItems = async () => {
    if (!currentPool.value?.id) {
      items.value = [];
      return;
    }
    try {
      const { data } = await getPoolItems(currentPool.value.id);
      items.value = data || [];
    } catch (err: any) {
      Message.error(err.message || '获取样式明细失败');
    }
  };

  const reloadItems = async () => {
    await Promise.all([loadPools(), loadItems()]);
    emit('loadData');
  };

  const onPoolSaved = async () => {
    await loadPools();
    if (currentPool.value?.id) {
      await loadItems();
    }
    emit('loadData');
  };

  const showItemsClick = async (pool: NpcBeautyPoolForm) => {
    currentPool.value = pool;
    await loadItems();
    // 点"样式明细"后把明细卡片滚进可视区 (池列表还有 10 行, 否则要手动往下拉)
    await nextTick();
    const el = itemsCardRef.value?.$el;
    if (el && typeof el.scrollIntoView === 'function') {
      el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  };

  const addPoolClick = async () => {
    if (categories.value.length === 0) {
      await loadCategories();
    }
    poolFormRef.value.initAdd(categories.value);
  };

  const editPoolClick = async (pool: NpcBeautyPoolForm) => {
    if (categories.value.length === 0) {
      await loadCategories();
    }
    poolFormRef.value.initEdit(pool, categories.value);
  };

  const removePoolClick = async (pool: NpcBeautyPoolForm) => {
    try {
      await deletePool({ id: pool.id } as NpcBeautyPoolForm);
      Message.success('删除成功！');
      if (currentPool.value?.id === pool.id) {
        currentPool.value = null;
        items.value = [];
      }
      await loadPools();
      emit('loadData');
    } catch (err: any) {
      Message.error(err.message || '删除失败');
    }
  };

  const addItemClick = () => {
    poolItemFormRef.value.initAdd(
      currentPool.value?.id,
      currentPool.value?.beautyType,
      items.value.length + 1
    );
  };

  const editItemClick = (item: NpcBeautyPoolItemForm) => {
    poolItemFormRef.value.initEdit(
      { ...item, poolId: currentPool.value?.id },
      currentPool.value?.beautyType
    );
  };

  const removeItemClick = async (item: NpcBeautyPoolItemForm) => {
    try {
      await deletePoolItem({
        id: item.id,
        poolId: currentPool.value?.id,
      } as NpcBeautyPoolItemForm);
      Message.success('删除成功！');
      await reloadItems();
    } catch (err: any) {
      Message.error(err.message || '删除失败');
    }
  };

  const openPickerClick = () => {
    if (!currentPool.value?.id) {
      Message.warning('请先选择资源池');
      return;
    }
    poolItemPickerRef.value.initPicker({
      poolId: currentPool.value.id,
      poolName: currentPool.value.poolName,
      categoryName: currentPool.value.categoryName,
      beautyType: currentPool.value.beautyType,
      serviceMode: currentPool.value.serviceMode,
      gender: currentPool.value.gender,
      items: items.value,
    });
  };

  const poolFormRef = ref();
  const poolItemFormRef = ref();
  const poolItemPickerRef = ref();

  const handleCancel = () => {
    visible.value = false;
  };

  // 打开弹窗
  const initManager = async () => {
    visible.value = true;
    await Promise.all([loadPools(), loadCategories()]);
  };

  defineExpose({ initManager });
</script>

<script lang="ts">
  export default {
    name: 'NpcBeautyPoolManager',
  };
</script>

<style lang="less" scoped>
  :deep(.current-pool-row) td {
    background-color: #e8f3ff;
  }
</style>
