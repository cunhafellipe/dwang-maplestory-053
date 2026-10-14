<template>
  <a-modal
    v-model:visible="visible"
    :ok-loading="loading"
    :on-before-ok="handleBeforeOk"
    :width="920"
    @cancel="handleCancel"
  >
    <template #title>
      批量配置样式明细 - {{ poolName || `池 ${poolId}` }}
      <span v-if="categoryName" style="color: #86909c"
        >({{ categoryName }})</span
      >
    </template>

    <div>
      <a-space wrap style="margin-bottom: 8px">
        <a-tag color="blue">类型: {{ beautyType || '-' }}</a-tag>
        <a-tag color="purple">模式: {{ serviceMode || '-' }}</a-tag>
        <a-tag>性别: {{ genderText(poolGender) }}</a-tag>
        <a-tag color="arcoblue">已选: {{ selectedIds.length }}</a-tag>
      </a-space>

      <a-alert v-if="!isWzType" type="warning" style="margin-bottom: 8px">
        该分类不是发型/脸型 (Character.wz)，请手工填写样式 ID (皮肤样式 ID 形如
        0 / 1 / 2 / 4)。
      </a-alert>

      <template v-else>
        <a-space wrap style="margin-bottom: 8px">
          <a-input-number
            v-model="keyword"
            placeholder="按样式 ID 搜索"
            allow-clear
            style="width: 170px"
          />
          <a-select v-model="genderFilter" style="width: 130px">
            <a-option :value="-1">全部性别</a-option>
            <a-option :value="0">只看男</a-option>
            <a-option :value="1">只看女</a-option>
          </a-select>
          <a-switch
            v-model="hideSelected"
            type="round"
            :checked-value="true"
            :unchecked-value="false"
          >
            <template #checked>隐藏已选</template>
            <template #unchecked>显示已选</template>
          </a-switch>
          <a-button size="small" @click="selectAllFiltered"
            >全选当前筛选</a-button
          >
          <a-button size="small" @click="clearSelected">清空已选</a-button>
          <a-tag>候选 {{ filteredStyles.length }} 个</a-tag>
        </a-space>

        <a-spin :loading="stylesLoading" style="width: 100%">
          <div class="style-grid">
            <a-empty
              v-if="filteredStyles.length === 0"
              description="没有匹配的样式"
            />
            <div
              v-for="style in filteredStyles"
              :key="style.styleId"
              class="style-card"
              :class="{ selected: isSelected(style.styleId) }"
              @click="toggleStyle(style.styleId)"
            >
              <img
                :src="getIconUrl('item', style.styleId)"
                alt=""
                @error="hideBrokenIcon"
              />
              <div class="style-id">{{ style.styleId }}</div>
              <div class="style-name" :title="style.styleName || ''">
                {{ style.styleName || '-' }}
              </div>
              <div class="style-gender">{{
                style.gender === 1 ? '女' : '男'
              }}</div>
              <a-tag v-if="style.configured" color="orange">已配置</a-tag>
            </div>
          </div>
        </a-spin>
      </template>

      <a-divider style="margin: 12px 0" />

      <a-space style="margin-bottom: 8px">
        <a-input-number
          v-model="manualStyleId"
          placeholder="手工添加样式 ID"
          style="width: 200px"
        />
        <a-button
          size="small"
          type="primary"
          status="success"
          @click="addManualStyle"
        >
          添加
        </a-button>
      </a-space>

      <div class="selected-box">
        <a-empty
          v-if="selectedIds.length === 0"
          description="尚未选择任何样式"
        />
        <div
          v-for="(styleId, idx) in selectedIds"
          :key="styleId"
          class="selected-row"
        >
          <span>
            {{ idx + 1 }}. 样式
            <b>{{ styleId }}</b>
            <span style="margin-left: 6px">{{ styleName(styleId) }}</span>
            <img
              :src="getIconUrl('item', styleId)"
              style="width: 20px; vertical-align: middle; margin-left: 6px"
              alt=""
              @error="hideBrokenIcon"
            />
          </span>
          <a-space>
            <a-button size="mini" :disabled="idx === 0" @click="moveUp(idx)"
              >上移</a-button
            >
            <a-button
              size="mini"
              :disabled="idx === selectedIds.length - 1"
              @click="moveDown(idx)"
            >
              下移
            </a-button>
            <a-button size="mini" status="danger" @click="removeStyle(idx)"
              >移除</a-button
            >
          </a-space>
        </div>
      </div>
      <div style="color: #86909c; margin-top: 6px">
        顺序即游戏内展示顺序 (sort_order)，保存时会整池覆盖该资源池的样式明细。
      </div>
    </div>
  </a-modal>
</template>

<script lang="ts" setup>
  import { ref, computed, watch } from 'vue';
  import useLoading from '@/hooks/loading';
  import { Message } from '@arco-design/web-vue';
  import { getIconUrl, hideBrokenIcon } from '@/utils/mapleStoryAPI';
  import {
    BeautyWzStyle,
    NpcBeautyPoolItemForm,
    getWzStyles,
    savePoolItems,
  } from '@/api/npcBeauty';

  interface PickerOptions {
    poolId?: number;
    poolName?: string;
    categoryName?: string;
    beautyType?: string;
    serviceMode?: string;
    gender?: number;
    items?: NpcBeautyPoolItemForm[];
  }

  const { loading, setLoading } = useLoading(false);
  const visible = ref<boolean>(false);
  const stylesLoading = ref(false);

  const poolId = ref<number | undefined>(undefined);
  const poolName = ref<string>('');
  const categoryName = ref<string>('');
  const beautyType = ref<string>('');
  const serviceMode = ref<string>('');
  const poolGender = ref<number | undefined>(undefined);

  const wzStyles = ref<BeautyWzStyle[]>([]);
  const selectedIds = ref<number[]>([]);
  const keyword = ref<number | undefined>(undefined);
  const genderFilter = ref<number>(-1);
  const hideSelected = ref<boolean>(false);
  const manualStyleId = ref<number | undefined>(undefined);

  const emit = defineEmits(['loadData']);

  const isWzType = computed(
    () => beautyType.value === 'HAIR' || beautyType.value === 'FACE'
  );

  const filteredStyles = computed(() => {
    let list = wzStyles.value;
    if (keyword.value !== undefined && keyword.value !== null) {
      const text = String(keyword.value);
      list = list.filter((style) => String(style.styleId).includes(text));
    }
    if (hideSelected.value) {
      list = list.filter((style) => !isSelected(style.styleId));
    }
    return list;
  });

  const genderText = (gender?: number) => {
    if (gender === -1) return '通用';
    if (gender === 1) return '女';
    if (gender === 0) return '男';
    return '-';
  };

  // 样式 ID -> 中文名 (来自后端回填的 styleName, 未知名显示 '-')
  const styleNameMap = ref<Record<number, string>>({});

  const mergeStyleNames = (list?: NpcBeautyPoolItemForm[]) => {
    const merged = { ...styleNameMap.value };
    (list || []).forEach((item) => {
      if (
        item.styleId !== undefined &&
        item.styleId !== null &&
        item.styleName
      ) {
        merged[item.styleId] = item.styleName;
      }
    });
    styleNameMap.value = merged;
  };

  const styleName = (styleId: number) => styleNameMap.value[styleId] || '-';

  const isSelected = (styleId?: number) =>
    styleId !== undefined &&
    styleId !== null &&
    selectedIds.value.includes(styleId);

  const toggleStyle = (styleId?: number) => {
    if (styleId === undefined || styleId === null) return;
    const index = selectedIds.value.indexOf(styleId);
    if (index >= 0) {
      selectedIds.value.splice(index, 1);
    } else {
      selectedIds.value.push(styleId);
    }
  };

  const removeStyle = (index: number) => {
    selectedIds.value.splice(index, 1);
  };

  const moveUp = (index: number) => {
    if (index <= 0) return;
    const list = selectedIds.value;
    const current = list[index];
    list[index] = list[index - 1];
    list[index - 1] = current;
  };

  const moveDown = (index: number) => {
    const list = selectedIds.value;
    if (index < 0 || index >= list.length - 1) return;
    const current = list[index];
    list[index] = list[index + 1];
    list[index + 1] = current;
  };

  const selectAllFiltered = () => {
    filteredStyles.value.forEach((style) => {
      if (!isSelected(style.styleId)) {
        selectedIds.value.push(style.styleId as number);
      }
    });
  };

  const clearSelected = () => {
    selectedIds.value = [];
  };

  const addManualStyle = () => {
    const styleId = manualStyleId.value;
    if (styleId === undefined || styleId === null) {
      Message.warning('请输入样式 ID');
      return;
    }
    if (!isSelected(styleId)) {
      selectedIds.value.push(styleId);
    }
    manualStyleId.value = undefined;
  };

  const loadStyles = async () => {
    wzStyles.value = [];
    if (!isWzType.value) {
      return;
    }
    stylesLoading.value = true;
    try {
      const { data } = await getWzStyles({
        beautyType: beautyType.value,
        gender: genderFilter.value === -1 ? undefined : genderFilter.value,
        poolId: poolId.value,
      });
      wzStyles.value = data || [];
      const merged = { ...styleNameMap.value };
      wzStyles.value.forEach((style) => {
        if (
          style.styleId !== undefined &&
          style.styleId !== null &&
          style.styleName
        ) {
          merged[style.styleId] = style.styleName;
        }
      });
      styleNameMap.value = merged;
    } catch (err: any) {
      Message.error(err.message || '读取 Character.wz 样式失败');
    } finally {
      stylesLoading.value = false;
    }
  };

  watch(genderFilter, () => {
    loadStyles();
  });

  const handleBeforeOk = async () => {
    if (!poolId.value) {
      Message.error('资源池 ID 不能为空');
      return false;
    }
    if (selectedIds.value.length === 0) {
      Message.error('请至少选择一个样式 (如需清空该池，请直接删除资源池)');
      return false;
    }
    setLoading(true);
    try {
      await savePoolItems({
        poolId: poolId.value,
        styleIds: selectedIds.value,
      });
      visible.value = false;
      Message.success('样式明细保存成功！');
      emit('loadData');
      return true;
    } catch (err: any) {
      Message.error(err.message || '保存失败');
      return false;
    } finally {
      setLoading(false);
    }
  };

  const handleCancel = () => {
    visible.value = false;
  };

  // 打开批量配置弹窗：按现有 sort_order 还原已选项，并读取 Character.wz 候选样式
  const initPicker = async (options: PickerOptions) => {
    poolId.value = options.poolId;
    poolName.value = options.poolName || '';
    categoryName.value = options.categoryName || '';
    beautyType.value = options.beautyType || '';
    serviceMode.value = options.serviceMode || '';
    poolGender.value = options.gender;
    keyword.value = undefined;
    hideSelected.value = false;
    genderFilter.value =
      options.gender === 0 || options.gender === 1 ? options.gender : -1;

    selectedIds.value = (options.items || [])
      .slice()
      .sort((a, b) => (a.sortOrder ?? 0) - (b.sortOrder ?? 0))
      .map((item) => item.styleId)
      .filter(
        (styleId): styleId is number =>
          styleId !== undefined && styleId !== null
      );

    // 先记录已有明细的中文名, 再拉取候选样式补齐名字
    styleNameMap.value = {};
    mergeStyleNames(options.items);

    visible.value = true;
    await loadStyles();
  };

  defineExpose({ initPicker });
</script>

<script lang="ts">
  export default {
    name: 'NpcBeautyPoolItemPicker',
  };
</script>

<style lang="less" scoped>
  .style-grid {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    max-height: 320px;
    overflow-y: auto;
    padding: 6px;
    border: 1px solid #e5e6eb;
    border-radius: 4px;
    width: 100%;
  }
  .style-card {
    width: 100px;
    padding: 4px;
    border: 1px solid #e5e6eb;
    border-radius: 4px;
    cursor: pointer;
    text-align: center;
    background: #ffffff;
  }
  .style-card.selected {
    border-color: #165dff;
    background: #e8f3ff;
  }
  .style-card img {
    width: 40px;
    height: 40px;
    object-fit: contain;
  }
  .style-id {
    font-size: 12px;
    line-height: 16px;
  }
  .style-name {
    font-size: 12px;
    line-height: 14px;
    color: #4e5969;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }
  .style-gender {
    font-size: 12px;
    color: #86909c;
    line-height: 14px;
  }
  .selected-box {
    max-height: 200px;
    overflow-y: auto;
    padding: 6px;
    border: 1px solid #e5e6eb;
    border-radius: 4px;
  }
  .selected-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 3px 4px;
    border-bottom: 1px dashed #f2f3f5;
  }
</style>
