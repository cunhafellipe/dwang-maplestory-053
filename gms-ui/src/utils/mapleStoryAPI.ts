/**
 * 获取icon图片地址
 * @param category 分类： item 或其他
 * @param id 物品id
 * @param location 地区：GMS（默认值）
 * @param version 版本：83（默认值）
 */
export function getIconUrl(
  category: string,
  id: string | number,
  location = 'GMS',
  version = '83'
): string {
  if (!id || id <= 0) return '';
  return `https://maplestory.io/api/${location}/${version}/${category}/${id}/icon`;
}

/**
 * img 标签 @error 回调：图标不存在时隐藏，避免出现碎裂占位图
 * 用法: <img :src="getIconUrl('item', id)" @error="hideBrokenIcon" />
 */
export function hideBrokenIcon(e: Event): void {
  const target = e.target as HTMLImageElement;
  if (target) {
    target.style.visibility = 'hidden';
  }
}

export function nothing() {
  return '占位用';
}
