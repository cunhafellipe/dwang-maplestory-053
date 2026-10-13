package org.gms.service;

import com.mybatisflex.core.query.QueryWrapper;
import org.gms.constants.npc.NpcFunc;
import org.gms.dao.entity.NpcFuncListDO;
import org.gms.dao.mapper.NpcFuncListMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

import static org.gms.dao.entity.table.NpcFuncListDOTableDef.NPC_FUNC_LIST_D_O;

/**
 * 显示所有的Npc的控制
 *
 * @author dwang
 * @version 1.0
 * @since 2026/10/13 13:58
 */
@Service
public class NpcFuncService {

    @Autowired
    private NpcFuncListMapper funcListMapper;

    public List<NpcFuncListDO> selectByType(String type) {
        return funcListMapper.selectListByQuery(QueryWrapper.create().where(NPC_FUNC_LIST_D_O.FUNC_TYPE.eq(type)));
    }

    public NpcFuncListDO selectByNpcIdAndType(Integer npcId, String type) {
        return funcListMapper.selectOneByQuery(QueryWrapper.create().where(NPC_FUNC_LIST_D_O.NPC_ID.eq(npcId)).and(NPC_FUNC_LIST_D_O.FUNC_TYPE.eq(type)));
    }

}
