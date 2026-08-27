import { modelValueType } from '../../constants/Constants'

const FILTER_DISPLAY_NAMES: Record<string, string> = {
  'origin': '原图',
  'rouguanglengzi': '柔光冷紫',
  'weibaolvjing': '微曝滤镜',
  'lengbaipi': '冷白皮',
  'qingtouguanggan': '清透光感',
  'ziran1': '自然1',
  'ziran2': '自然2',
  'ziran3': '自然3',
  'ziran4': '自然4',
  'ziran5': '自然5',
  'ziran6': '自然6',
  'ziran7': '自然7',
  'ziran8': '自然8',
  'zhiganhui1': '质感灰1',
  'zhiganhui2': '质感灰2',
  'zhiganhui3': '质感灰3',
  'zhiganhui4': '质感灰4',
  'zhiganhui5': '质感灰5',
  'zhiganhui6': '质感灰6',
  'zhiganhui7': '质感灰7',
  'zhiganhui8': '质感灰8',
  'mitao1': '蜜桃1',
  'mitao2': '蜜桃2',
  'mitao3': '蜜桃3',
  'mitao4': '蜜桃4',
  'mitao5': '蜜桃5',
  'mitao6': '蜜桃6',
  'mitao7': '蜜桃7',
  'mitao8': '蜜桃8',
  'bailiang1': '白亮1',
  'bailiang2': '白亮2',
  'bailiang3': '白亮3',
  'bailiang4': '白亮4',
  'bailiang5': '白亮5',
  'bailiang6': '白亮6',
  'bailiang7': '白亮7',
  'fennen1': '粉嫩1',
  'fennen2': '粉嫩2',
  'fennen3': '粉嫩3',
  'fennen5': '粉嫩5',
  'fennen6': '粉嫩6',
  'fennen7': '粉嫩7',
  'fennen8': '粉嫩8',
  'lengsediao1': '冷色调1',
  'lengsediao2': '冷色调2',
  'lengsediao3': '冷色调3',
  'lengsediao4': '冷色调4',
  'lengsediao7': '冷色调7',
  'lengsediao8': '冷色调8',
  'lengsediao11': '冷色调11',
  'nuansediao1': '暖色调1',
  'nuansediao2': '暖色调2',
  'gexing1': '个性1',
  'gexing2': '个性2',
  'gexing3': '个性3',
  'gexing4': '个性4',
  'gexing5': '个性5',
  'gexing7': '个性7',
  'gexing10': '个性10',
  'gexing11': '个性11',
  'xiaoqingxin1': '小清新1',
  'xiaoqingxin3': '小清新3',
  'xiaoqingxin4': '小清新4',
  'xiaoqingxin6': '小清新6',
  'heibai1': '黑白1',
  'heibai2': '黑白2',
  'heibai3': '黑白3',
  'heibai4': '黑白4'
};

export function sdkFilterName(filterName: string): string {
  // LiveDemo：UI 名 rouguanglengzi 对应 SDK 滤镜 roguanglengzi
  return filterName === 'rouguanglengzi' ? 'roguanglengzi' : filterName;
}

export class BeautyFilterModel {
  filterName: string = '';
  filterIndex: number = 0;
  filterLevel: number = 0.0;

  constructor(data: Record<string, modelValueType>) {
    this.filterName = data['filterName'] as string;
    this.filterIndex = data['filterIndex'] as number;
    this.filterLevel = data['filterLevel'] as number;
  }

  get displayName(): string {
    return FILTER_DISPLAY_NAMES[this.filterName] ?? this.filterName;
  }
}