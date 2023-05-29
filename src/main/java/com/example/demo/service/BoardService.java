package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dto.Board;
import com.example.demo.mapper.BoardMapper;

@Service
public class BoardService {

	@Autowired
	BoardMapper boardMapper;
	
	public List<Board> boardList(Map<String,Object> pMap) {
        List<Board> boardList = null;
        boardList =  boardMapper.boardList(pMap);
        return boardList;
	}
	
	public int boardDelete(Map<String,Object> pMap) {
		int result = 0;
		result = boardMapper.boardDelete(pMap);
		return result;
	}

	public List<Board> modifyList(Map<String, Object> pMap) {
        List<Board> modifyList = null;
        modifyList =  boardMapper.modifyList(pMap);
		
		return modifyList;
	}

	public void modify(Map<String, Object> pMap) {
		boardMapper.modify(pMap);
	}
}
