const List<String> pickupStatus = [
  'Waiting For Customer Preparation',
  'Pickup Requested',
  'In transit',
  'Arrived',
  'Customer Refused',
  'Customer Rescheduled',
  'No response From Customer',
];
const List<String> archiveReasons = [
  'Customer Has Dept',
  'Repeated',
  'No Response From Customer',
  'Customer Refused The Visit',
  'Customer Asked For Reschedule',
  'Customer Did Not Start The Business Yet',
  'There is No Problem',
  'Already Scheduled',
];

const List<String> reOpenReasons = [
  'Report is Incomplete',
  'Report Has Mistakes',
];
List<String> transitCategory = ['N/A', 'Tech', 'Courier'];
List<String> deliveryStatus = ['In Dispatch Area', 'In Transit', 'Delivered'];

const String PART_NO_KEY = 'partNo';
const String PART_DESC_KEY = 'desc';
const String PART_QTY_KEY = 'qty';
const String PRICE_KEY = 'price';
const String PART_IS_FREE_KEY = 'isFreePart';
const double VAT = 1.15;
