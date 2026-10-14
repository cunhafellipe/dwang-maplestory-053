<template>
  <a-modal
    v-model:visible="visible"
    :ok-loading="loading"
    :on-before-ok="handleBeforeOk"
    :width="620"
    @cancel="handleCancel"
  >
    <template #title>
      {{ formData.id ? '编辑 NPC 美容池绑定' : '新增 NPC 美容池绑定' }}
    </template>
    <div>
      <a-form
        :model="formData"
        label-col="{ span: 7 }"
        wrapper-col="{ span: 17 }"
      >
        <a-form-item label="NPC ID" required>
          <a-input-number
            v-model="formData.npcId"
            :disabled="!!formData.id"
            style="width: 100%"
          />
        </a-form-item>
        <a-form-item label="美容资源池" required>
          <a-select
            v-model="formData.poolId"
            placeholder="请选择要绑定的资源池"
            style="width: 100%"
          >
            <a-option v-for="pool in pools" :key="pool.id" :value="pool.id">
              {{ pool.poolName }} ({{ pool.categoryName || '-' }} /
              {{ genderText(pool.gender) }} / {{ pool.beautyType || '-' }})
            </a-option>
          </a-select>
        </a-form-item>
        <a-form-item label="会员卡/道具 ID" required>
          <a-space>
            <a-input-number
              v-model="formData.couponItemId"
              placeholder="如: 5150001"
              style="width: 200px"
            />
            <img
              v-if="formData.couponItemId"
              :src="getIconUrl('item', formData.couponItemId)"
              style="width: 24px"
              alt=""
              @error="hideBrokenIcon"
            />
          </a-space>
        </a-form-item>
        <a-form-item label="菜单排序">
          <a-input-number
            v-model="formData.sortOrder"
            :min="0"
            style="width: 200px"
          />
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
        <a-form-item v-if="selectedPool" label="资源池信息">
          <a-space wrap>
            <a-tag color="blue"
              >类型: {{ selectedPool.beautyType || '-' }}</a-tag
            >
            <a-tag color="purple"
              >模式: {{ selectedPool.serviceMode || '-' }}</a-tag
            >
            <a-tag>性别: {{ genderText(selectedPool.gender) }}</a-tag>
            <a-tag>明细数: {{ selectedPool.itemCount ?? 0 }}</a-tag>
          </a-space>
        </a-form-item>
      </a-form>
    </div>
  </a-modal>
</template>

<script lang="ts" setup>
  import { ref, computed } from 'vue';
  import useLoading from '@/hooks/loading';
  import { Message } from '@arco-design/web-vue';
  import { getIconUrl, hideBrokenIcon } from '@/utils/mapleStoryAPI';
  import {
    NpcBeautyMappingForm,
    NpcBeautyPoolForm,
    saveMapping,
  } from '@/api/npcBeauty';

  const { loading, setLoading } = useLoading(false);
  const visible = ref<boolean>(false);
  const pools = ref<NpcBeautyPoolForm[]>([]);
  const formData = ref<NpcBeautyMappingForm>({
    npcId: 0,
    poolId: undefined,
    couponItemId: undefined,
    sortOrder: 0,
    isActive: true,
  });

  const emit = defineEmits(['loadData']);

  const selectedPool = computed(() =>
    pools.value.find((pool) => pool.id === formData.value.poolId)
  );

  const genderText = (gender?: number) => {
    if (gender === -1) return '通用';
    if (gender === 1) return '女';
    if (gender === 0) return '男';
    return '-';
  };

  const handleBeforeOk = async () => {
    if (!formData.value.npcId) {
      Message.error('NPC ID 不能为空');
      return false;
    }
    if (!formData.value.poolId) {
      Message.error('请选择美容资源池');
      return false;
    }
    if (!formData.value.couponItemId) {
      Message.error('会员卡/道具 ID 不能为空');
      return false;
    }
    setLoading(true);
    try {
      await saveMapping(formData.value);
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

  // 新增绑定：传入 NPC ID 与可选的资源池列表
  const initAdd = (npcId: number, poolList: NpcBeautyPoolForm[]) => {
    pools.value = poolList || [];
    formData.value = {
      id: undefined,
      npcId,
      poolId: undefined,
      couponItemId: undefined,
      sortOrder: 0,
      isActive: true,
    };
    visible.value = true;
  };

  // 编辑绑定：传入已有绑定关系
  const initEdit = (
    mapping: NpcBeautyMappingForm,
    poolList: NpcBeautyPoolForm[]
  ) => {
    pools.value = poolList || [];
    formData.value = {
      id: mapping.id,
      npcId: mapping.npcId,
      poolId: mapping.poolId,
      couponItemId: mapping.couponItemId,
      sortOrder: mapping.sortOrder ?? 0,
      isActive: mapping.isActive ?? true,
    };
    visible.value = true;
  };

  defineExpose({ initAdd, initEdit });
</script>

<script lang="ts">
  export default {
    name: 'NpcBeautyMappingForm',
  };
</script>
