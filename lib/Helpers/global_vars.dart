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
  'يوجد مبالغ مستحقة على العميل',
  'في انتظار تصدير الفاتورة',
  'مكرر',
  'لا يوجد رد من العميل',
  'العميل رفض الزيارة',
  'العميل طلب تأجيل الزيارة',
  'لم يتم التشغيل',
  'العميل من طرف موزع',
  'تم رفض الزيارة بسبب الرسوم',
  'لا توجد مشكلة',
  'تمت زيارة العميل',
  'تم اسناد التذكرة لفني من قبل',
];

const List<String> reOpenReasons = [
  'التقرير غير مكتمل',
  'التقرير يحتوي على أخطاء',
  'تم صيانة مكينة غير المذكورة في التقرير',
];
List<String> transitCategory = ['N/A', 'Tech', 'Courier'];
List<String> deliveryStatus = ['In Dispatch Area', 'In Transit', 'Delivered'];
