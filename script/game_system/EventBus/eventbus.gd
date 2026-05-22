extends Node

signal scene_load_progress_changes(progress: Array[float])	## 场景加载进度改变
signal scene_load_finished		## 场景加载完成

#region 交互器列表相关
signal append_on_interactors(interactor: Interactor)	## 在交互器列表增加交互器
signal erase_on_interactors(interactor: Interactor)		## 在交互器列表增移除交互器
#endregion
