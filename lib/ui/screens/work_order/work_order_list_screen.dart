import 'package:maintboard/core/models/work_order_checklist/section_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maintboard/core/services/date_time_service.dart';
import 'package:maintboard/core/services/shared_preference_service.dart';
import 'package:maintboard/core/services/work_order_service.dart';
import 'package:maintboard/search_provider.dart';
import 'package:maintboard/ui/screens/work_order/work_order_detail_screen.dart';
import 'package:maintboard/widgets/work_order_card.dart';

class WorkOrderListScreen extends ConsumerStatefulWidget {
  const WorkOrderListScreen({super.key});

  @override
  ConsumerState<WorkOrderListScreen> createState() =>
      _WorkOrderListScreenState();
}

class _WorkOrderListScreenState extends ConsumerState<WorkOrderListScreen>
    with SingleTickerProviderStateMixin {
  List _workOrders = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
    _tabController.addListener(() => _fetchWorkOrders(isRefresh: true));
    _fetchWorkOrders();
  }

  Future<void> _fetchWorkOrders({bool isRefresh = false}) async {
    if (isRefresh) setState(() => _isLoading = true);

    try {
      final siteID = await SharedPreferenceService.getCurrentSiteID();
      final searchQuery = ref.read(searchQueryProvider);

      final queryParams = {
        'siteID': siteID,
        'pageNumber': 0,
        'rowsPerPage': 25,
        'searchTerm': searchQuery,
        'sort': 'plannedEndDT_ASC',
      };

      final now = DateTime.now();
      switch (_tabController.index) {
        case 0:
          queryParams['overdueOnly'] = true;
          break;
        case 1:
          queryParams['plannedEndDT'] =
              DateTimeService.getIsoUtcDayRange(now, now);
          break;
        case 2:
          final monday = now.subtract(Duration(days: now.weekday - 1));
          final sunday = monday.add(const Duration(days: 6));
          queryParams['plannedEndDT'] =
              DateTimeService.getIsoUtcDayRange(monday, sunday);
          break;
        case 3:
          break;
      }

      final fetchedWorkOrders =
      await WorkOrderService().fetchWorkOrders(queryParams: queryParams);

      setState(() {
        _workOrders = fetchedWorkOrders;
      });
    } catch (e) {
      debugPrint("Error fetching work orders: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(searchQueryProvider, (prev, next) {
      if (prev != next) _fetchWorkOrders(isRefresh: true);
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Overdue'),
            Tab(text: 'Today'),
            Tab(text: 'This Week'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => _fetchWorkOrders(isRefresh: true),
        child: _workOrders.isEmpty
            ? const Center(child: Text('No work orders found'))
            : ListView.builder(
          itemCount: _workOrders.length,
          itemBuilder: (context, index) {
            final order = _workOrders[index];
            return WorkOrderCard(
              title: order.title,
              workOrderNumber: order.workOrderNumber,
              priorityID: order.priorityID,
              workOrderStatusID: order.workOrderStatusID,
              workOrderID: order.workOrderID,
              assetName: order.assetName,
              dueDate: order.plannedEndDT!,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => WorkOrderDetailScreen(
                        workOrderID: order.workOrderID)),
              ),
            );
          },
        ),
      ),
    );
  }
}
