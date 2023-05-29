package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.Board;
import com.example.demo.service.BoardService;

import lombok.extern.log4j.Log4j2;

@Controller
@RequestMapping("/board")
@Log4j2
public class MainController {

	@Autowired
	BoardService boardService;
	
	@GetMapping("/list")
	public String boardList(@RequestParam Map<String, Object> pMap, Model model) {
		log.info(pMap);
		List<Board> boardList = boardService.boardList(pMap);	
		log.info(boardList);
		model.addAttribute("result", boardList);		
		return "board";
	}
	
	@GetMapping("/search")
	public ResponseEntity<List<Board>> boardList(@RequestParam Map<String, Object> pMap) {
	    log.info(pMap);
	    List<Board> boardList = boardService.boardList(pMap);
	    log.info(boardList);
	    return ResponseEntity.ok(boardList);
	}	
	
	@GetMapping("/modify")
	public String boardmodify(@RequestParam Map<String, Object> pMap, Model model) {		
		log.info(pMap);
		List<Board> modifyList = boardService.modifyList(pMap);
		log.info(modifyList);
		model.addAttribute("modifyList", modifyList);
		return "boardmodify";
	}
	
	@PostMapping("/upload")
	public String handleUpload(@RequestBody Map<String, Object> pMap) {
		log.info(pMap);
		boardService.modify(pMap);
		return "redirect:/board/list";
	}
	
	
	@PostMapping("/delete")
	public ResponseEntity<String> boardDelete(@RequestBody Map<String, Object> pMap) {
		int result = 0;
		log.info(pMap);
		result = boardService.boardDelete(pMap);
		log.info(result);
		if(result == 0) {
		    String responseMessage = "삭제가 실패.";
		    return ResponseEntity.ok(responseMessage);
		} else {
			String responseMessage = "삭제 완료";
			return ResponseEntity.ok(responseMessage);
		}
	}	
}
