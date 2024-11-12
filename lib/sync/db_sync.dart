// class DbSync {
//   Future<void> initSync({required String uid}) async {
//     /*
//     Case: Không có local db
//       - Tạo db: '${user.uid}.db'
//       - Đẩy lên Firebase Storage -> lấy metadata
//       - Tạo collection: 
//         {
//           userId: '${user.uid}',
//           dbMetadata: '...'
//         }
//     Case: Có local db
//       Case: user.uid == nameOf(localDb hiện tại);
//         - Sync db lên Firebase Storage
//       Case: user.uid != nameOf(localDb hiện tại):
//         - Sync localDb này lên Firebase Storage cho user có uid là tên của db
//         - Xoá db này
//           Case: Có db của user này trên Firebase Storage 
//           + Lưu db của user này về local
//           Case: Chưa có db của user 
//           + Tạo db: '${user.uid}.db'
//           + Đẩy lên Firebase Storage -> lấy metadata
//           + Tạo collection: 
//             {
//               userId: '${user.uid}',
//               dbMetadata: '...'
//             }
//     */

    

//   }
// }