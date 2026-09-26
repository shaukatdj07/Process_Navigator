import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/document_item_model.dart';
import '../models/process_model.dart';
import '../models/process_step_model.dart';

/// Local, bundled sample content so the app is fully demoable offline and
/// on first launch, before a remote content service is wired up in Phase 2.
/// Swap this for a real API/CMS-backed [ProcessRepository] implementation
/// without touching any UI or provider code (Dependency Inversion).
class LocalProcessData {
  const LocalProcessData._();

  static final List<CategoryModel> categories = [
    const CategoryModel(
      id: 'vehicles',
      name: 'Vehicles',
      icon: Icons.directions_car_filled_rounded,
      processCount: 3,
    ),
    const CategoryModel(
      id: 'documents',
      name: 'Documents',
      icon: Icons.badge_rounded,
      processCount: 2,
    ),
    const CategoryModel(
      id: 'property',
      name: 'Property',
      icon: Icons.home_work_rounded,
      processCount: 1,
    ),
    const CategoryModel(
      id: 'certificates',
      name: 'Certificates',
      icon: Icons.workspace_premium_rounded,
      processCount: 2,
    ),
    const CategoryModel(
      id: 'business',
      name: 'Business',
      icon: Icons.storefront_rounded,
      processCount: 1,
    ),
    const CategoryModel(
      id: 'nocs',
      name: 'NOCs',
      icon: Icons.fact_check_rounded,
      processCount: 1,
    ),
  ];

  static final List<ProcessModel> processes = [
    ProcessModel(
      id: 'vehicle_transfer',
      categoryId: 'vehicles',
      title: 'Vehicle Ownership Transfer',
      summary:
          'Transfer a vehicle from seller to buyer with the correct forms and fee.',
      documents: const [
        DocumentItemModel(
          id: 'd1',
          title: 'Original registration book',
          copies: 1,
        ),
        DocumentItemModel(
          id: 'd2',
          title: 'CNIC copies (buyer & seller)',
          copies: 2,
          attestationRequired: true,
        ),
        DocumentItemModel(id: 'd3', title: 'Form TR/Transfer form', copies: 1),
        DocumentItemModel(
          id: 'd4',
          title: 'Paid token tax receipt',
          copies: 1,
        ),
      ],
      office: const OfficeInfo(
        name: 'Excise & Taxation Office',
        address: 'Matches the city saved in your profile',
        timings: 'Mon–Sat, 9:00 AM – 3:00 PM',
      ),
      fee: const FeeInfo(
        baseFee: 3500,
        notes: 'Varies by vehicle engine capacity and district.',
        dependsOnVehicleType: true,
      ),
      submit: const SubmitInfo(
        instructions: [
          'Submit the transfer form with attested CNIC copies at the counter.',
          'Pay the calculated fee and collect the deposit slip.',
          'Hand in the registration book for endorsement.',
        ],
        receiptNote: 'Keep the deposit slip — it is required for collection.',
      ),
      nextStep: const NextStepInfo(
        timeline: '7–10 working days',
        followUp: 'Collect the updated registration book from the same office.',
      ),
      source: SourceInfo(
        sourceName: 'Punjab Excise & Taxation Department',
        url: 'https://excise.punjab.gov.pk',
        lastVerified: DateTime(2026, 9, 1),
      ),
    ),
    ProcessModel(
      id: 'token_tax_renewal',
      categoryId: 'vehicles',
      title: 'Annual Token Tax Renewal',
      summary: 'Renew your vehicle token tax before it expires.',
      documents: const [
        DocumentItemModel(id: 'd1', title: 'Registration book', copies: 1),
        DocumentItemModel(id: 'd2', title: 'CNIC copy', copies: 1),
      ],
      office: const OfficeInfo(
        name: 'Excise & Taxation Office / e-Pay Punjab',
        address: 'Online or nearest office',
        timings: '24/7 online, or office hours in person',
      ),
      fee: const FeeInfo(
        baseFee: 1500,
        notes: 'Depends on engine capacity.',
        dependsOnVehicleType: true,
      ),
      submit: const SubmitInfo(
        instructions: [
          'Pay online via e-Pay Punjab or at the office counter.',
          'Save the digital or printed receipt.',
        ],
        receiptNote: 'Receipt doubles as proof of a valid token.',
      ),
      nextStep: const NextStepInfo(
        timeline: 'Immediate',
        followUp: 'Set a reminder for next year\'s renewal.',
      ),
      source: SourceInfo(
        sourceName: 'e-Pay Punjab',
        url: 'https://epay.punjab.gov.pk',
        lastVerified: DateTime(2026, 8, 20),
      ),
    ),
    ProcessModel(
      id: 'driving_license_renewal',
      categoryId: 'vehicles',
      title: 'Driving License Renewal',
      summary: 'Renew an expiring or expired driving license.',
      documents: const [
        DocumentItemModel(id: 'd1', title: 'Original CNIC', copies: 1),
        DocumentItemModel(
          id: 'd2',
          title: 'Old license (original)',
          copies: 1,
        ),
        DocumentItemModel(
          id: 'd3',
          title: 'Passport-size photographs',
          copies: 2,
        ),
      ],
      office: const OfficeInfo(
        name: 'Driving License Authority (Traffic Police)',
        address: 'Matches the city saved in your profile',
        timings: 'Mon–Sat, 9:00 AM – 4:00 PM',
      ),
      fee: const FeeInfo(baseFee: 2000, notes: 'Fixed fee for renewal.'),
      submit: const SubmitInfo(
        instructions: [
          'Submit the renewal form with your old license and CNIC.',
          'Get an eye test done on-site if required.',
          'Pay the fee and get your token number.',
        ],
        receiptNote: 'Keep the token number to track and collect your license.',
      ),
      nextStep: const NextStepInfo(
        timeline: '3–5 working days',
        followUp: 'Collect the new license using your token number.',
      ),
      source: SourceInfo(
        sourceName: 'Punjab Traffic Police',
        url: 'https://ptp.punjab.gov.pk',
        lastVerified: DateTime(2026, 9, 10),
      ),
    ),
    ProcessModel(
      id: 'cnic_renewal',
      categoryId: 'documents',
      title: 'CNIC Renewal',
      summary: 'Renew an expiring or expired Computerised National ID Card.',
      documents: const [
        DocumentItemModel(id: 'd1', title: 'Old CNIC (original)', copies: 1),
        DocumentItemModel(
          id: 'd2',
          title: 'Family Registration Certificate',
          copies: 1,
        ),
      ],
      office: const OfficeInfo(
        name: 'NADRA Registration Centre',
        address: 'Nearest NADRA centre to your saved city',
        timings: 'Mon–Sat, 8:30 AM – 4:00 PM',
      ),
      fee: const FeeInfo(baseFee: 750, notes: 'Normal processing fee.'),
      submit: const SubmitInfo(
        instructions: [
          'Fill Form-B at the centre or online via NADRA e-Sahulat.',
          'Biometric verification at the counter.',
          'Pay the fee and collect a tracking slip.',
        ],
        receiptNote: 'Tracking slip is required for status checks.',
      ),
      nextStep: const NextStepInfo(
        timeline: '7–15 working days for normal processing',
        followUp: 'Track status with your tracking ID on NADRA\'s portal.',
      ),
      source: SourceInfo(
        sourceName: 'NADRA',
        url: 'https://www.nadra.gov.pk',
        lastVerified: DateTime(2026, 9, 5),
      ),
    ),
    ProcessModel(
      id: 'passport_renewal',
      categoryId: 'documents',
      title: 'Passport Renewal',
      summary: 'Renew a Pakistani passport before it expires.',
      documents: const [
        DocumentItemModel(id: 'd1', title: 'Old passport', copies: 1),
        DocumentItemModel(id: 'd2', title: 'CNIC copy', copies: 1),
      ],
      office: const OfficeInfo(
        name: 'Regional Passport Office',
        address: 'Nearest office to your saved city',
        timings: 'Mon–Fri, 8:30 AM – 3:00 PM',
      ),
      fee: const FeeInfo(baseFee: 4500, notes: 'Normal, 5-year booklet.'),
      submit: const SubmitInfo(
        instructions: [
          'Apply online via the Passport Directorate portal.',
          'Visit the office on your appointment slot for biometrics.',
        ],
        receiptNote: 'Keep the online application tracking number.',
      ),
      nextStep: const NextStepInfo(
        timeline: '2–3 weeks for normal processing',
        followUp: 'Track status online and collect from the same office.',
      ),
      source: SourceInfo(
        sourceName: 'Directorate General of Immigration & Passports',
        url: 'https://dgip.gov.pk',
        lastVerified: DateTime(2026, 8, 28),
      ),
    ),
    ProcessModel(
      id: 'property_transfer',
      categoryId: 'property',
      title: 'Property Registry Transfer',
      summary: 'Transfer registry of a property between two parties.',
      documents: const [
        DocumentItemModel(id: 'd1', title: 'Sale deed', copies: 2),
        DocumentItemModel(
          id: 'd2',
          title: 'CNIC copies (both parties)',
          copies: 2,
          attestationRequired: true,
        ),
        DocumentItemModel(id: 'd3', title: 'Property tax receipts', copies: 1),
      ],
      office: const OfficeInfo(
        name: 'Sub-Registrar / Housing Authority Office',
        address: 'Office matching the property\'s location',
        timings: 'Mon–Fri, 9:00 AM – 2:00 PM',
      ),
      fee: const FeeInfo(
        baseFee: 15000,
        notes: 'Depends on property value and district DC rate.',
      ),
      submit: const SubmitInfo(
        instructions: [
          'Submit sale deed and CNIC copies for verification.',
          'Pay stamp duty and registration fee.',
          'Biometric verification of both parties.',
        ],
        receiptNote: 'Keep the registration receipt for record and future sale.',
      ),
      nextStep: const NextStepInfo(
        timeline: '15–20 working days',
        followUp: 'Collect the updated registry copy from the same office.',
      ),
      source: SourceInfo(
        sourceName: 'Punjab Land Records Authority',
        url: 'https://plra.punjab.gov.pk',
        lastVerified: DateTime(2026, 9, 12),
      ),
    ),
    ProcessModel(
      id: 'character_certificate',
      categoryId: 'certificates',
      title: 'Police Character Certificate',
      summary: 'Obtain a character certificate for jobs or visas.',
      documents: const [
        DocumentItemModel(id: 'd1', title: 'CNIC copy', copies: 1),
        DocumentItemModel(
          id: 'd2',
          title: 'Passport-size photographs',
          copies: 2,
        ),
      ],
      office: const OfficeInfo(
        name: 'District Police Office / e-Khidmat Markaz',
        address: 'Matches the city saved in your profile',
        timings: 'Mon–Sat, 9:00 AM – 5:00 PM',
      ),
      fee: const FeeInfo(baseFee: 500, notes: 'Fixed application fee.'),
      submit: const SubmitInfo(
        instructions: [
          'Submit the application with CNIC and photographs.',
          'Biometric verification at the counter.',
        ],
        receiptNote: 'Keep the application receipt to track and collect.',
      ),
      nextStep: const NextStepInfo(
        timeline: '5–7 working days',
        followUp: 'Collect from the same office with your receipt.',
      ),
      source: SourceInfo(
        sourceName: 'Punjab Police e-Khidmat',
        url: 'https://punjabpolice.gov.pk',
        lastVerified: DateTime(2026, 8, 15),
      ),
    ),
    ProcessModel(
      id: 'domicile_certificate',
      categoryId: 'certificates',
      title: 'Domicile Certificate',
      summary: 'Apply for a domicile certificate for your district.',
      documents: const [
        DocumentItemModel(id: 'd1', title: 'CNIC copy', copies: 1),
        DocumentItemModel(
          id: 'd2',
          title: 'Proof of residence',
          copies: 1,
          attestationRequired: true,
        ),
      ],
      office: const OfficeInfo(
        name: 'Deputy Commissioner (DC) Office',
        address: 'District DC office matching your saved city',
        timings: 'Mon–Fri, 9:00 AM – 3:00 PM',
      ),
      fee: const FeeInfo(baseFee: 500, notes: 'Fixed application fee.'),
      submit: const SubmitInfo(
        instructions: [
          'Submit the domicile form with proof of residence.',
          'Verification by the local Patwari/Tehsildar.',
        ],
        receiptNote: 'Keep the application slip issued at submission.',
      ),
      nextStep: const NextStepInfo(
        timeline: '10–15 working days',
        followUp: 'Collect the certificate from the DC office.',
      ),
      source: SourceInfo(
        sourceName: 'District Government Office',
        url: 'https://openpunjab.punjab.gov.pk',
        lastVerified: DateTime(2026, 7, 30),
      ),
    ),
    ProcessModel(
      id: 'business_registration',
      categoryId: 'business',
      title: 'Sole Proprietorship Registration',
      summary: 'Register a small business as a sole proprietor.',
      documents: const [
        DocumentItemModel(id: 'd1', title: 'CNIC copy', copies: 1),
        DocumentItemModel(
          id: 'd2',
          title: 'Business address proof',
          copies: 1,
        ),
      ],
      office: const OfficeInfo(
        name: 'FBR / Regional Tax Office',
        address: 'Online via IRIS, or nearest RTO',
        timings: 'Online 24/7, office Mon–Fri 9 AM–4 PM',
      ),
      fee: const FeeInfo(baseFee: 0, notes: 'NTN registration is free.'),
      submit: const SubmitInfo(
        instructions: [
          'Register on FBR\'s IRIS portal.',
          'Fill business details and submit for NTN issuance.',
        ],
        receiptNote: 'Save your NTN certificate PDF.',
      ),
      nextStep: const NextStepInfo(
        timeline: 'Same day to 3 working days',
        followUp: 'Use the NTN to open a business bank account.',
      ),
      source: SourceInfo(
        sourceName: 'Federal Board of Revenue',
        url: 'https://iris.fbr.gov.pk',
        lastVerified: DateTime(2026, 9, 3),
      ),
    ),
    ProcessModel(
      id: 'noc_construction',
      categoryId: 'nocs',
      title: 'Construction NOC',
      summary: 'Obtain a No-Objection Certificate before construction.',
      documents: const [
        DocumentItemModel(id: 'd1', title: 'Ownership documents', copies: 1),
        DocumentItemModel(id: 'd2', title: 'Building plan/map', copies: 2),
      ],
      office: const OfficeInfo(
        name: 'Development Authority (LDA/RDA/etc.)',
        address: 'Authority matching your property\'s city',
        timings: 'Mon–Fri, 9:00 AM – 3:00 PM',
      ),
      fee: const FeeInfo(
        baseFee: 8000,
        notes: 'Depends on plot size and category.',
      ),
      submit: const SubmitInfo(
        instructions: [
          'Submit ownership documents and building plan for review.',
          'Pay the scrutiny fee.',
          'Site inspection scheduled by the authority.',
        ],
        receiptNote: 'Keep the file number for tracking.',
      ),
      nextStep: const NextStepInfo(
        timeline: '20–30 working days',
        followUp: 'Collect the approved NOC and start construction as per plan.',
      ),
      source: SourceInfo(
        sourceName: 'Lahore Development Authority',
        url: 'https://lda.gop.pk',
        lastVerified: DateTime(2026, 8, 10),
      ),
    ),
  ];
}
