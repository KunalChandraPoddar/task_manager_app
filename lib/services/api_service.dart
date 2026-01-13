// import 'package:dio/dio.dart';
// import '../models/task_model.dart';

// class ApiService {
//   static final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: 'https://jsonplaceholder.typicode.com',
//     ),
//   );

//   static Future<List<Task>> fetchTasks() async {
//     final response = await _dio.get('/todos');
//     return (response.data as List)
//         .map((json) => Task.fromJson(json))
//         .toList();
//   }

//   static Future<void> updateTaskCompletion(
//     int taskId,
//     bool completed,
//   ) async {
//     await _dio.patch(
//       '/todos/$taskId',
//       data: {'completed': completed},
//     );
//   }
// }
