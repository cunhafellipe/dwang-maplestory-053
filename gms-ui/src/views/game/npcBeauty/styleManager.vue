<template>
  <a-modal
    v-model:visible="visible"
    :footer="false"
    :width="1200"
    title="样式管理 (053 wz 全部发型 / 脸型)"
    @cancel="handleCancel"
  >
    <a-spin :loading="loading" style="width: 100%">
      <a-tabs v-model:active-key="activeTab" type="card-gutter">
        <a-tab-pane v-for="tab in TABS" :key="tab.key" :title="tab.title" />
      </a-tabs>

      <a-space wrap style="margin: 10px 0">
        <a-input-number
          v-model="keyword"
          placeholder="按样式 ID 搜索"
          allow-clear
          style="width: 160px"
        />
        <a-input
          v-model="nameKeyword"
          placeholder="按名称搜索"
          allow-clear
          style="width: 160px"
        />
        <a-switch
          v-model="onlyUnused"
          type="round"
          :checked-value="true"
          :unchecked-value="false"
        >
          <template #checked>只看未引用</template>
          <template #unchecked>显示全部</template>
        </a-switch>
        <a-button size="small" @click="loadStyles(true)">刷新</a-button>
        <a-tag color="arcoblue">共 {{ styles.length }} 个样式</a-tag>
        <a-tag :color="unusedCount > 0 ? 'orange' : 'green'">
          未被资源池引用 {{ unusedCount }} 个
        </a-tag>
        <a-button
          type="primary"
          status="success"
          size="small"
          :disabled="selectedKeys.length === 0"
          @click="openPoolPicker()"
        >
          批量加入资源池 (已选 {{ selectedKeys.length }})
        </a-button>
      </a-space>

      <a-table
        v-model:selectedKeys="selectedKeys"
        :data="filteredStyles"
        row-key="styleId"
        :row-selection="rowSelection"
        :pagination="stylePagination"
        :scroll="{ y: 430 }"
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
            title="样式 ID"
            data-index="styleId"
            :width="100"
            align="center"
          />
          <a-table-column title="名称" data-index="styleName" :width="150">
            <template #cell="{ record }">
              {{ record.styleName || '-' }}
            </template>
          </a-table-column>
          <a-table-column title="引用次数" :width="100" align="center">
            <template #cell="{ record }">
              <a-tag :color="record.refCount > 0 ? 'arcoblue' : 'red'">
                {{ record.refCount ?? 0 }}
              </a-tag>
            </template>
          </a-table-column>
          <a-table-column title="所属资源池 (引用了它的池)">
            <template #cell="{ record }">
              <a-space v-if="record.pools && record.pools.length" wrap>
                <a-tag v-for="p in record.pools" :key="p.poolId" color="green">
                  {{ p.poolName }}
                  <span style="color: #86909c">· {{ p.categoryName }}</span>
                </a-tag>
              </a-space>
              <a-tag v-else color="orange">未被任何资源池引用</a-tag>
            </template>
          </a-table-column>
          <a-table-column
            title="操作"
            :width="110"
            fixed="right"
            align="center"
          >
            <template #cell="{ record }">
              <a-button
                type="text"
                size="mini"
                @click="openPoolPicker(record.styleId)"
              >
                加入池子
              </a-button>
            </template>
          </a-table-column>
        </template>
      </a-table>

      <div style="color: #86909c; margin-top: 8px">
        引用次数 = 有多少个 npc_beauty_pool 把它配进了 npc_beauty_pool_item；0
        表示这个样式还没有被任何池使用。
      </div>
    </a-spin>

    <!-- 批量加入资源池 -->
    <a-modal
      v-model:visible="poolPickVisible"
      title="批量加入资源池"
      :width="860"
      :ok-loading="adding"
      :on-before-ok="handleAddToPools"
      @cancel="poolPickVisible = false"
    >
      <a-alert type="info" style="margin-bottom: 8px">
        已选样式 {{ pickedStyleIds.length }} 个：{{
          pickedStyleIds.slice(0, 24).join(', ')
        }}{{ pickedStyleIds.length > 24 ? ' …' : '' }}
      </a-alert>
      <a-input
        v-model="poolKeyword"
        placeholder="按池名 / 分类 / 类型 过滤"
        allow-clear
        style="width: 280px; margin-bottom: 8px"
      />
      <a-table
        v-model:selectedKeys="pickedPoolIds"
        :data="filteredPools"
        row-key="id"
        :row-selection="poolRowSelection"
        :pagination="false"
        :scroll="{ y: 340 }"
        bordered
        size="small"
      >
        <template #columns>
          <a-table-column
            title="池 ID"
            data-index="id"
            :width="80"
            align="center"
          />
          <a-table-column title="池名称" data-index="poolName" :width="230">
            <template #cell="{ record }">
              {{ record.poolName }}
              <a-tag v-if="pickedHasMap[record.id]" color="green">已加入</a-tag>
            </template>
          </a-table-column>
          <a-table-column title="所属分类" :width="190">
            <template #cell="{ record }">
              {{ record.categoryName || '-' }}
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
          <a-table-column title="性别" :width="80" align="center">
            <template #cell="{ record }">
              <a-tag :color="genderColor(record.gender)">
                {{ genderText(record.gender) }}
              </a-tag>
            </template>
          </a-table-column>
          <a-table-column
            title="现有明细"
            data-index="itemCount"
            :width="90"
            align="center"
          />
          <a-table-column title="已包含选中的样式" :width="150" align="center">
            <template #cell="{ record }">
              <a-tag :color="pickedHasMap[record.id] ? 'orange' : 'gray'">
                {{ pickedHasMap[record.id] || 0 }} / {{ pickedStyleIds.length }}
              </a-tag>
            </template>
          </a-table-column>
        </template>
      </a-table>
      <div style="color: #86909c; margin-top: 6px">
        默认勾选的是「这些样式已经加入的池」（左侧打勾 +
        绿色「已加入」标记），方便看出之前加过哪些；
        确认时已存在的样式会自动跳过、不会重复插入，新增的样式按顺序追加到池子末尾。
        如需从某个池里移除样式，请到「美容资源池管理 → 样式明细」里删除。
      </div>
    </a-modal>
  </a-modal>
</template>

<script lang="ts" setup>
  import { ref, reactive, computed, watch } from 'vue';
  import useLoading from '@/hooks/loading';
  import { Message } from '@arco-design/web-vue';
  import { getIconUrl, hideBrokenIcon } from '@/utils/mapleStoryAPI';
  import {
    addStylesToPools,
    getBeautyPools,
    getStyleOverview,
    BeautyStyleOverview,
    NpcBeautyPoolForm,
  } from '@/api/npcBeauty';

  const TABS = [
    { key: 'HAIR-0', title: '男发型' },
    { key: 'HAIR-1', title: '女发型' },
    { key: 'FACE-0', title: '男脸' },
    { key: 'FACE-1', title: '女脸' },
  ];

  const { loading, setLoading } = useLoading(false);
  const visible = ref<boolean>(false);
  const activeTab = ref<string>('HAIR-0');

  const stylesByTab = ref<Record<string, BeautyStyleOverview[]>>({
    'HAIR-0': [],
    'HAIR-1': [],
    'FACE-0': [],
    'FACE-1': [],
  });
  const loaded = ref<Record<string, boolean>>({});
  const selectedKeys = ref<(string | number)[]>([]);
  const keyword = ref<number | undefined>(undefined);
  const nameKeyword = ref<string>('');
  const onlyUnused = ref<boolean>(false);

  const stylePagination = reactive({
    pageSize: 20,
    showTotal: true,
    showPageSize: true,
    pageSizeOptions: [20, 50, 100],
  });
  const rowSelection = { type: 'checkbox', showCheckedAll: true } as const;

  const pools = ref<NpcBeautyPoolForm[]>([]);
  const poolPickVisible = ref<boolean>(false);
  const adding = ref<boolean>(false);
  const pickedStyleIds = ref<number[]>([]);
  const pickedPoolIds = ref<(string | number)[]>([]);
  const poolKeyword = ref<string>('');
  const poolRowSelection = { type: 'checkbox', showCheckedAll: true } as const;

  const emit = defineEmits(['loadData']);

  const styles = computed(() => stylesByTab.value[activeTab.value] || []);

  const unusedCount = computed(
    () => styles.value.filter((item) => !item.refCount).length
  );

  const filteredStyles = computed(() => {
    let list = styles.value;
    if (keyword.value !== undefined && keyword.value !== null) {
      const text = String(keyword.value);
      list = list.filter((item) => String(item.styleId).includes(text));
    }
    if (nameKeyword.value) {
      list = list.filter((item) =>
        (item.styleName || '').includes(nameKeyword.value)
      );
    }
    if (onlyUnused.value) {
      list = list.filter((item) => !item.refCount);
    }
    return list;
  });

  // 每个池已经包含了多少个"当前选中的样式"
  const pickedHasMap = computed(() => {
    const map: Record<number, number> = {};
    pickedStyleIds.value.forEach((styleId) => {
      const style = styles.value.find((item) => item.styleId === styleId);
      (style?.pools || []).forEach((ref) => {
        if (ref.poolId) {
          map[ref.poolId] = (map[ref.poolId] || 0) + 1;
        }
      });
    });
    return map;
  });

  const filteredPools = computed(() => {
    const text = poolKeyword.value.trim();
    if (!text) return pools.value;
    return pools.value.filter(
      (pool) =>
        (pool.poolName || '').includes(text) ||
        (pool.categoryName || '').includes(text) ||
        (pool.beautyType || '').includes(text)
    );
  });

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

  // 加载当前 tab 的样式总览 (带缓存, force = true 强制刷新)
  const loadStyles = async (force = false) => {
    const key = activeTab.value;
    if (!force && loaded.value[key]) return;
    const [beautyType, gender] = key.split('-');
    setLoading(true);
    try {
      const { data } = await getStyleOverview({
        beautyType,
        gender: Number(gender),
      });
      stylesByTab.value[key] = data || [];
      loaded.value[key] = true;
    } catch (err: any) {
      Message.error(err.message || '获取样式总览失败');
    } finally {
      setLoading(false);
    }
  };

  // tab 切换: 清空勾选并懒加载该 tab 的数据 (用 watch 保证拿到的是新 key)
  watch(activeTab, () => {
    selectedKeys.value = [];
    keyword.value = undefined;
    nameKeyword.value = '';
    loadStyles();
  });
  const loadPools = async () => {
    try {
      const { data } = await getBeautyPools();
      pools.value = data || [];
    } catch (err: any) {
      Message.error(err.message || '获取资源池失败');
    }
  };

  // 打开"批量加入资源池" (不传 styleId 就用表格里勾选的)
  const openPoolPicker = async (styleId?: number) => {
    pickedStyleIds.value = styleId
      ? [styleId]
      : selectedKeys.value.map((key) => Number(key));
    if (pickedStyleIds.value.length === 0) {
      Message.warning('请先勾选要加入的样式');
      return;
    }
    if (pools.value.length === 0) {
      await loadPools();
    }
    // 默认勾选"已经包含这些样式的池", 这样能一眼看出之前加过哪些
    const alreadyIn = new Set<number>();
    pickedStyleIds.value.forEach((id) => {
      const style = styles.value.find((item) => item.styleId === id);
      (style?.pools || []).forEach((ref) => {
        if (ref.poolId) {
          alreadyIn.add(ref.poolId);
        }
      });
    });
    pickedPoolIds.value = Array.from(alreadyIn);
    poolKeyword.value = '';
    poolPickVisible.value = true;
  };

  const handleAddToPools = async () => {
    if (pickedPoolIds.value.length === 0) {
      Message.error('请选择至少一个资源池');
      return false;
    }
    adding.value = true;
    try {
      const { data } = await addStylesToPools({
        styleIds: pickedStyleIds.value,
        poolIds: pickedPoolIds.value.map((key) => Number(key)),
      });
      Message.success(`已新增 ${data ?? 0} 条样式明细（已存在的自动跳过）`);
      poolPickVisible.value = false;
      selectedKeys.value = [];
      await Promise.all([loadStyles(true), loadPools()]);
      emit('loadData');
      return true;
    } catch (err: any) {
      Message.error(err.message || '加入失败');
      return false;
    } finally {
      adding.value = false;
    }
  };

  const handleCancel = () => {
    visible.value = false;
  };

  // 打开弹窗
  const initManager = async () => {
    visible.value = true;
    selectedKeys.value = [];
    await loadStyles();
    if (pools.value.length === 0) {
      await loadPools();
    }
  };

  defineExpose({ initManager });
</script>

<script lang="ts">
  export default {
    name: 'NpcBeautyStyleManager',
  };
</script>
