import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/app_theme.dart';
import '../salon/presentation/salon_screen.dart';
import '../../common_widgets/big_voice_button.dart';
import '../voice/logic/voice_command_processor.dart';
import '../real_estate/presentation/real_estate_screen.dart'; // Dòng import đã được di chuyển lên đây

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isListening = false;
  final _voiceProcessor = VoiceCommandProcessor();

  final List<Widget> _pages = [
    const SalonScreen(),
    const RealEstateScreen(), // Màn hình Đất đai
    const Center(child: Text("Cài đặt", style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _startListening() async {
    setState(() => _isListening = true);
    
    // Giả lập delay nghe (Simulation)
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isListening = false);
    
    // Giả lập kết quả (Mock result để demo cho User xem trước)
    _showResultDialog("Ghi nợ bà Sáu năm trăm rưỡi");
  }

  void _stopListening() {
    setState(() => _isListening = false);
  }

  void _showResultDialog(String text) {
    final action = _voiceProcessor.processText(text);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Text("MÁY NGHE ĐƯỢC LÀ:", style: TextStyle(fontSize: 20.sp)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("\"$text\"", style: TextStyle(fontSize: 22.sp, fontStyle: FontStyle.italic, color: Colors.blue[800])),
            SizedBox(height: 20.h),
            const Divider(),
            Text("Ý cô là:", style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
            SizedBox(height: 10.h),
            Row(
              children: [
                if (action.intent == VoiceIntent.addDebt)
                   Icon(Icons.warning, color: Colors.red, size: 30.sp),
                SizedBox(width: 10.w),
                Text("GHI NỢ", style: TextStyle(fontSize: 24.sp, color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8.h),
            Text("Khách: ${action.customerName ?? '???'}", style: TextStyle(fontSize: 20.sp)),
            Text("Tiền: ${action.amount} đ", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("SAI RỒI", style: TextStyle(fontSize: 20.sp, color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h)
            ),
            child: Text("ĐÚNG RỒI", style: TextStyle(fontSize: 20.sp, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      // Nút Voice nằm ở giữa màn hình (Floating)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: BigVoiceButton(
          isListening: _isListening,
          onRecordStart: _startListening,
          onRecordStop: _stopListening,
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80.h, 
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.cut, size: 32),
              label: 'TIỆM TÓC',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.landscape, size: 32),
              label: 'ĐẤT ĐAI',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 32),
              label: 'CÀI ĐẶT',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppTheme.primaryGreen,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}