#  UploadImgJsonOperation
开发中常见情景，比如发送一条微博动态，用户可以在本地界面编辑好一条微博动态上传服务器，上传后要清除本机暂存档，这条微博包含文本JSON和一张图片，所以上传微博动态的工作就包含上传JSON文件和图片两个内容，并且在用户上传过程中可以随时取消，让用户继续编辑重新上传这个微博动态，这比较适合用NSOperation写。

