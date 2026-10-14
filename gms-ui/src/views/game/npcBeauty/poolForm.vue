<template>
  <a-modal
    v-model:visible="visible"
    :ok-loading="loading"
    :on-before-ok="handleBeforeOk"
    :width="600"
    @cancel="handleCancel"
  >
    <template #title>
      {{ formData.id ? '编辑美容资源池' : '新增美容资源池' }}
    </template>
    <div>
      <a-form
        :model="formData"
        label-col="{ span: 7 }"
        wrapper-col="{ span: 17 }"
      >
        <a-form-item label="资源池标识" required>
          <a-input
            v-model="formData.poolName"
            placeholder="如: henesys_vip_male_hair"
          />
        </a-form-item>
        <a-form-item label="所属分类" required>
          <a-select
            v-model="formData.categoryId"
            placeholder="请选择美容主分类 (npc_beauty_cat)"
            style="width: 100%"
          >
            <a-option v-for="cat in categories" :key="cat.id" :value="cat.id">
              [Menu {{ cat.menuIndex }}] {{ cat.categoryName }} ({{
                cat.beautyType
              }}
              / {{ cat.serviceMode }})
            </a-option>
          </a-select>
        </a-form-item>
        <a-form-item label="适用性别">
          <a-select v-model="formData.gender" style="width: 200px">
            <a-option :value="-1">-1 通用</a-option>
            <a-option :value="0">0 男</a-option>
            <a-option :value="1">1 女</a-option>
          </a-select>
        </a-form-item>
        <a-form-item label="开关">
          <a-switch
            v-model="formData.isActive"
            type="round"
            :checked-value="true"
            :unchecked-value="false"
          >
            <template #checked>启用</template>
            <template #unchecked>停用</template>
          </a-switch>
        </a-form-item>
        <a-form-item v-if="selectedCategory" label="分类信息">
          <a-space wrap>
            <a-tag color="blue">类型: {{ selectedCategory.beautyType }}</a-tag>
            <a-tag color="purple"
              >模式: {{ selectedCategory.serviceMode }}</a-tag
            >
            <a-tag :color="selectedCategory.isRandom ? 'orange' : 'green'">
              {{ selectedCategory.isRandom ? '普通随机' : 'VIP自选' }}
            </a-tag>
          </a-space>
        </a-form-item>
        <a-form-item v-if="formData.id" label="样式明细数">
          <a-tag color="arcoblue">{{ formData.itemCount ?? 0 }}</a-tag>
          <span style="margin-left: 8px; color: #86909c">
            (明细请在详情页的“批量配置样式明细”中维护)
          </span>
        </a-form-item>
      </a-form>
    </div>
  </a-modal>
</template>

<script lang="ts" setup>
  import { ref, computed } from 'vue';
  import useLoading from '@/hooks/loading';
  import { Message } from '@arco-design/web-vue';
  import { NpcBeautyCat, NpcBeautyPoolForm, savePool } from '@/api/npcBeauty';

  const { loading, setLoading } = useLoading(false);
  const visible = ref<boolean>(false);
  const categories = ref<NpcBeautyCat[]>([]);
  const formData = ref<NpcBeautyPoolForm>({
    poolName: '',
    categoryId: undefined,
    gender: -1,
    isActive: true,
  });

  const emit = defineEmits(['loadData']);

  const selectedCategory = computed(() =>
    categories.value.find((cat) => cat.id === formData.value.categoryId)
  );

  const handleBeforeOk = async () => {
    if (!formData.value.poolName) {
      Message.error('资源池标识不能为空');
      return false;
    }
    if (!formData.value.categoryId) {
      Message.error('请选择所属分类');
      return false;
    }
    setLoading(true);
    try {
      await savePool(formData.value);
      visible.value = false;
      Message.success(formData.value.id ? '更新成功！' : '新增成功！');
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

  // 新增资源池
  const initAdd = (categoryList: NpcBeautyCat[]) => {
    categories.value = categoryList || [];
    formData.value = {
      id: undefined,
      poolName: '',
      categoryId: undefined,
      gender: -1,
      isActive: true,
      itemCount: 0,
    };
    visible.value = true;
  };

  // 编辑资源池
  const initEdit = (pool: NpcBeautyPoolForm, categoryList: NpcBeautyCat[]) => {
    categories.value = categoryList || [];
    formData.value = {
      id: pool.id,
      poolName: pool.poolName,
      categoryId: pool.categoryId,
      gender: pool.gender ?? -1,
      isActive: pool.isActive ?? true,
      itemCount: pool.itemCount ?? 0,
    };
    visible.value = true;
  };

  defineExpose({ initAdd, initEdit });
</script>

<script lang="ts">
  export default {
    name: 'NpcBeautyPoolForm',
  };
</script>
