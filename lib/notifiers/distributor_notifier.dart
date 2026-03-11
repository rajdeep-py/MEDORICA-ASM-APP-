import 'package:flutter_riverpod/legacy.dart';
import '../models/distributor.dart';

class DistributorNotifier extends StateNotifier<List<Distributor>> {
  DistributorNotifier()
    : super([
        Distributor(
          id: '1',
          name: 'Metro Pharma Distributors',
          location: 'New Delhi',
          phoneNo: '+91 98765 43210',
          email: 'contact@metropharma.com',
          address: '123 Medical Lane, Delhi',
          photoUrl: null,
          minimumOrderValue: 50000,
          deliveryTime: '24-48 hours',
          description:
              'Leading pharmaceutical distributor in North India with 15+ years of experience. Specializes in oncology and cardiology medications.',
        ),
        Distributor(
          id: '2',
          name: 'Apollo Healthcare Solutions',
          location: 'Mumbai',
          phoneNo: '+91 87654 32109',
          email: 'sales@apollohealth.com',
          address: '456 Pharmacy Road, Mumbai',
          photoUrl: null,
          minimumOrderValue: 75000,
          deliveryTime: '24 hours',
          description:
              'Premium distributor with state-of-the-art warehousing facilities. Serves major hospitals and clinics across Western India.',
        ),
        Distributor(
          id: '3',
          name: 'Wellness Hub Distribution',
          location: 'Bangalore',
          phoneNo: '+91 76543 21098',
          email: 'info@wellnesshub.com',
          address: '789 Health Street, Bangalore',
          photoUrl: null,
          minimumOrderValue: 40000,
          deliveryTime: '48 hours',
          description:
              'Trusted distributor in South India with focus on generic medications. Known for competitive pricing and reliable delivery.',
        ),
        Distributor(
          id: '4',
          name: 'HealthFirst Distributors',
          location: 'Hyderabad',
          phoneNo: '+91 65432 10987',
          email: 'business@healthfirst.com',
          address: '321 Medical Hub, Hyderabad',
          photoUrl: null,
          minimumOrderValue: 60000,
          deliveryTime: '36 hours',
          description:
              'Emerging distributor with focus on affordable medications. Rapidly expanding network across South and Central India.',
        ),
        Distributor(
          id: '5',
          name: 'Care Logistics Pharma',
          location: 'Pune',
          phoneNo: '+91 54321 09876',
          email: 'logistics@carecare.com',
          address: '654 Pharma Lane, Pune',
          photoUrl: null,
          minimumOrderValue: 45000,
          deliveryTime: '48 hours',
          description:
              'Specialized in fast-moving pharmaceuticals with efficient cold chain management for sensitive medications.',
        ),
      ]);

  void searchDistributors(String query) {
    if (query.isEmpty) {
      // Reset to all distributors
      state = state;
    } else {
      state = state
          .where(
            (d) =>
                d.name.toLowerCase().contains(query.toLowerCase()) ||
                d.location.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
  }
}
