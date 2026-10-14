<template>
  <a-modal
    v-model:visible="visible"
    :ok-loading="loading"
    :on-before-ok="handleBeforeOk"
    :width="540"
    @cancel="handleCancel"
  >
    <template #title>
      {{ formData.id ? '编辑样式明细' : '新增样式明细' }}
    </template>
    <div>
      <a-form
        :model="formData"
        label-col="{ span: 7 }"
        wrapper-col="{ span: 17 }"
      >
        <a-form-item label="资源池 ID">
          <a-input-number
            v-model="formData.poolId"
            disabled
            style="width: 100%"
          />
        </a-form-item>
        <a-form-item label="样式 ID" required>
          <a-space>
            <a-input-number
              v-model="formData.styleId"
              placeholder="如: 30000 / 20000"
              style="width: 200px"
            />
            <img
              v-if="formData.styleId || formData.styleId === 0"
              :src="getIconUrl('item', formData.styleId)"
              style="width: 24px"
              alt=""
              @error="hideBrokenIcon"
            />
          </a-space>
        </a-form-item>
        <a-form-item label="排序">
          <a-input-number
            v-model="formData.sortOrder"
            :min="0"
            style="width: 200px"
          />
        </a-form-item>
        <a-form-item v-if="beautyType || styleName" label="样式说明">
          <a-space wrap>
            <a-tag v-if="beautyType" color="blue">{{ beautyType }}</a-tag>
            <a-tag v-if="styleName" color="arcoblue">{{ styleName }}</a-tag>
            <span style="color: #86909c">
              只填最基础的样式 ID 即可，颜色/瞳色偏移由游戏内自动处理
            </span>
          </a-space>
        </a-form-item>
      </a-form>
    </div>
  </a-modal>
</template>

<script lang="ts" setup>
  import { ref } from 'vue';
  import useLoading from '@/hooks/loading';
  import { Message } from '@arco-design/web-vue';
  import { getIconUrl, hideBrokenIcon } from '@/utils/mapleStoryAPI';
  import { NpcBeautyPoolItemForm, savePoolItem } from '@/api/npcBeauty';

  const { loading, setLoading } = useLoading(false);
  const visible = ref<boolean>(false);
  const beautyType = ref<string>('');
  const styleName = ref<string>('');
  const formData = ref<NpcBeautyPoolItemForm>({
    poolId: undefined,
    styleId: undefined,
    sortOrder: 0,
  });

  const emit = defineEmits(['loadData']);

  const handleBeforeOk = async () => {
    if (!formData.value.poolId) {
      Message.error('资源池 ID 不能为空');
      return false;
    }
    if (
      formData.value.styleId === undefined ||
      formData.value.styleId === null
    ) {
      Message.error('样式 ID 不能为空');
      return false;
    }
    setLoading(true);
    try {
      await savePoolItem(formData.value);
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

  // 新增单条样式明细
  const initAdd = (poolId?: number, type?: string, sortOrder?: number) => {
    beautyType.value = type || '';
    styleName.value = '';
    formData.value = {
      id: undefined,
      poolId,
      styleId: undefined,
      sortOrder: sortOrder ?? 0,
    };
    visible.value = true;
  };

  // 编辑单条样式明细
  const initEdit = (item: NpcBeautyPoolItemForm, type?: string) => {
    beautyType.value = type || '';
    styleName.value = item.styleName || '';
    formData.value = {
      id: item.id,
      poolId: item.poolId,
      styleId: item.styleId,
      sortOrder: item.sortOrder ?? 0,
    };
    visible.value = true;
  };

  defineExpose({ initAdd, initEdit });
</script>

<script lang="ts">
  export default {
    name: 'NpcBeautyPoolItemForm',
  };
</script>
