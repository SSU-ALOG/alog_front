import 'dart:async';
import 'dart:developer';

import 'package:alog/main.dart';
import 'package:flutter/material.dart';

// dummy data
final List<Map<String, String>> events = [
  {'status': '진행중', 'date': '2024-10-04', 'description': ' event'},
  {'status': '상황종료', 'date': '2024-10-03', 'description': 'event'},
  {'status': '상황종료', 'date': '2024-10-02', 'description': ' event'},
  {'status': '진행중', 'date': '2024-10-01', 'description': ' event'},
  {'status': '긴급', 'date': '2024-10-01', 'description': ' event'},
  {'status': '긴급', 'date': '2024-10-10', 'description': ' event'},
  {'status': '진행중', 'date': '2024-10-03', 'description': ' event'},
];


// Disaster Categories
const List<String> disasterCategories = [
  'ALL',
  '범죄',
  '화재',
  '건강위해',
  '안전사고',
  '자연재해',
  '재난',
  '동식물 재난',
  '도시 서비스',
  '디지털 서비스',
  '기타'
];

// Status list
const List<String> disasterStatusList = [
  'ALL',
  '진행중',
  '상황종료',
  '긴급',
];

// set ColorSet class for matching main color and shade color
class ColorSet {
  final Color main;
  final Color shade;

  const ColorSet({required this.main, required this.shade});
}

// Disaster status colors
const Map<String, ColorSet> disasterStatusColors = {
  'ALL': ColorSet(main: Color(0xFFFF6969), shade: Color(0xFFFFE2E5)),
  // 배경 빨간색
  '진행중': ColorSet(main: Color(0xFFFFB37C), shade: Color(0xFFFFF4E4)),
  // 배경 주황색
  '상황종료': ColorSet(main: Color(0xFF3AC0A0), shade: Color(0xFFE7F4E8)),
  // 배경 초록색
  '긴급': ColorSet(main: Colors.redAccent, shade: Color(0xFFFFE2E5))
  // 배경 빨간색 (텍스트 색상도 빨간색)
};

// Disaster status icons
const Map<String, IconData> disasterStatusIcons = {
  '진행중': Icons.error_rounded,
  '상황종료': Icons.check_circle,
  '긴급': Icons.circle_notifications_rounded
};

// region list
const List<String> regions = [
  'ALL',
  '서울특별시',
  '부산광역시',
  '대구광역시',
  '인천광역시',
  '광주광역시',
  '대전광역시',
  '울산광역시',
  '세종특별자치시',
  '경기도',
  '충청북도',
  '충청남도',
  '전라남도',
  '경상북도',
  '경상남도',
  '강원특별자치도',
  '전북특별자치도',
  '제주특별자치도'
];

class IncidentScreen extends StatefulWidget {
  const IncidentScreen({Key? key}) : super(key: key);

  @override
  _IncidentScreenState createState() => _IncidentScreenState();
}

class _IncidentScreenState extends State<IncidentScreen> {
  Set<String> _selectedDisaster = {'ALL'};

  void _disasterToggleFilter(String filter) {
    setState(() {
      if (filter == 'ALL') {
        // ALL 선택 시 다른 필터를 해제
        _selectedDisaster.clear();
        _selectedDisaster.add('ALL');
      } else {
        // 다른 필터 선택 시 ALL 해제
        if (_selectedDisaster.contains('ALL')) {
          _selectedDisaster.remove('ALL');
        }
        if (_selectedDisaster.contains(filter)) {
          _selectedDisaster.remove(filter);
        } else {
          _selectedDisaster.add(filter);
        }
      }
      // 선택된 필터가 없을 시 자동으로 ALL 선택
      if (_selectedDisaster.isEmpty) {
        _selectedDisaster.add('ALL');
      }
    });
  }

  Set<String> _selectedDisasterStatus = {'ALL'};

  void _disasterStatusToggleFilter(String filter) {
    setState(() {
      if (filter == 'ALL') {
        // ALL 선택 시 다른 필터를 해제
        _selectedDisasterStatus.clear();
        _selectedDisasterStatus.add('ALL');
      } else {
        // 다른 필터 선택 시 ALL 해제
        if (_selectedDisasterStatus.contains('ALL')) {
          _selectedDisasterStatus.remove('ALL');
        }
        if (_selectedDisasterStatus.contains(filter)) {
          _selectedDisasterStatus.remove(filter);
        } else {
          _selectedDisasterStatus.add(filter);
        }
      }
      // 선택된 필터가 없을 시 자동으로 ALL 선택
      if (_selectedDisasterStatus.isEmpty) {
        _selectedDisasterStatus.add('ALL');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar- main.dart
        backgroundColor: Colors.white,
        body: Column(children: [
          // 검색창, 필터 버튼 등 고정된 상단 위젯
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 검색창
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1.0),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefix: const SizedBox(width: 20),
                        hintText: '검색어를 입력해주세요',
                        suffixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),

                // Disaster Category part
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: disasterCategories
                          .map(
                            (filter) => DisasterFilterChip(
                              label: filter,
                              isSelected: _selectedDisaster.contains(filter),
                              onSelected: () => _disasterToggleFilter(filter),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                // Disaster Status part
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: disasterStatusList
                          .map(
                            (filter) => DisasterStatusFilterChip(
                              label: filter,
                              isSelected:
                                  _selectedDisasterStatus.contains(filter),
                              onSelected: () =>
                                  _disasterStatusToggleFilter(filter),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),

                // Regions
                RegionDropDown(),
                SizedBox(height: 5.0),
              ],
            ),
          ),

          // Accidents list
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0), // 좌우 10px 여백 추가
              child: ListView(
                children: [
                  for (var event in sortEventsByDate(events)) // 정렬된 이벤트 리스트 순회
                    Builder(
                      builder: (context) {

                        // 상태에 따라 데이터 가져오기
                        final colorSet = getDisasterColorSet(event['status']!);
                        final icon = getDisasterIcon(event['status']!);
                        return EventCard(
                          status: event['status']!,
                          date: event['date']!,
                          description: event['description']!,
                          backgroundColor: colorSet.shade,
                          iconColor: colorSet.main,
                          icon: icon,
                        );
                      },
                    ),

                  // EventCard(
                  //   status: '진행 중',
                  //   date: '2024.10.03',
                  //   description: 'Description. Lorem ipsum dolor sit amet.',
                  //   backgroundColor: Color(0xFFFFF4E4),
                  //   iconColor: Color(0xFFFFB37C),
                  //   icon: disasterStatusIcons['진행중'],
                  // ),
                  // EventCard(
                  //   status: '상황 종료',
                  //   date: '2024.10.03',
                  //   description: 'Description. Lorem ipsum dolor sit amet.',
                  //   backgroundColor: Color(0xFFE7F4E8),
                  //   iconColor: Color(0xFF3AC0A0),
                  //   icon: disasterStatusIcons['상황종료'],
                  // ),
                  // EventCard(
                  //   status: '진행 중',
                  //   date: '2024.10.03',
                  //   description: 'Description. Lorem ipsum dolor sit amet.',
                  //   backgroundColor: Color(0xFFFFF4E4),
                  //   iconColor: Color(0xFFFFB37C),
                  //   icon: disasterStatusIcons['진행중'],
                  // ),
                  // EventCard(
                  //   status: '상황 종료',
                  //   date: '2024.10.03',
                  //   description: 'Description. Lorem ipsum dolor sit amet.',
                  //   backgroundColor: Color(0xFFE7F4E8),
                  //   iconColor: Color(0xFF3AC0A0),
                  //   icon: disasterStatusIcons['상황종료'],
                  // ),
                  // EventCard(
                  //   status: '긴급 재난',
                  //   date: '2024.10.03',
                  //   description: 'Description. Lorem ipsum dolor sit amet.',
                  //   backgroundColor: Color(0xFFFFE2E5),
                  //   iconColor: Color(0xFFFF6969),
                  //   icon: disasterStatusIcons['긴급'],
                  // ),
                  // EventCard(
                  //   status: '긴급 재난',
                  //   date: '2024.10.03',
                  //   description: 'Description. Lorem ipsum dolor sit amet.',
                  //   backgroundColor: Color(0xFFFFE2E5),
                  //   iconColor: Color(0xFFFF6969),
                  //   icon: disasterStatusIcons['긴급'],
                  // ),
                ],
              ),
            ), // Container
          )
        ]));
  }
}

// Disaster Category filter widget
class DisasterFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const DisasterFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: onSelected,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFFF6969) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(0, 0)),
            ],
            border: Border.all(
              color: isSelected ? Color(0xFFFF6969) : Colors.grey.shade300,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Disaster Status filter widget
class DisasterStatusFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  DisasterStatusFilterChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: onSelected,
        child: Container(
          decoration: BoxDecoration(
            color:
                isSelected ? disasterStatusColors[label]!.main : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(0, 0)),
            ],
            border: Border.all(
              color: isSelected
                  ? disasterStatusColors[label]!.main
                  : Colors.grey.shade300,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : disasterStatusColors[label]!.main,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Region Dropdown widget
class RegionDropDown extends StatefulWidget {
  @override
  _RegionDropDownState createState() => _RegionDropDownState();
}

class _RegionDropDownState extends State<RegionDropDown> {
  String? _selectedRegion = 'ALL';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('      지역:'),
        SizedBox(width: 8.0),
        DropdownButton<String>(
          value: _selectedRegion,
          items: regions
              .map((region) => DropdownMenuItem(
                    value: region,
                    child: Text(region),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedRegion = value; // 선택 값 update
            });
          },
        ),
      ], // children
    );
  }
}

// set default event design
ColorSet getDisasterColorSet(String status){
  return disasterStatusColors[status] ?? ColorSet(
    main: Colors.grey,
    shade: Colors.grey.shade200,
  );
}

IconData getDisasterIcon(String status){
  return disasterStatusIcons[status] ?? Icons.error_rounded;
}

// sort event using date
List<Map<String, String>> sortEventsByDate(List<Map<String, String>> event){
  events.sort((a, b){
    DateTime dateA = DateTime.parse(a['date']!);
    DateTime dateB = DateTime.parse(b['date']!);
    return dateB.compareTo(dateA); // 최신순 정렬
  });

  return events;
}

class EventCard extends StatelessWidget {
  final String status;
  final String date;
  final String description;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  final double iconSize;

  const EventCard({
    required this.status,
    required this.date,
    required this.description,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    this.iconSize = 30.0
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: iconSize
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  '발생일시: $date',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 8.0),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
