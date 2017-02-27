if !exists('g:loaded_ctrlp') || !g:loaded_ctrlp
	finish
endif

command! CtrlpProject call ctrlp#init(ctrlp#project#id())
