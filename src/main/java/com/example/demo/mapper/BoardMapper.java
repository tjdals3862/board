package com.example.demo.mapper;


import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.example.demo.dto.Board;

@Mapper
@Repository
public interface BoardMapper {
	
	List<Board> boardList(Map<String,Object> pMap);

	int boardDelete(Map<String,Object> pMap);

	List<Board> modifyList(Map<String, Object> pMap);

	int modify(Map<String, Object> pMap);
	

}
