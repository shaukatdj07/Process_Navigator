import '../models/document_item_model.dart';
import '../models/process_model.dart';
import '../models/process_step_model.dart';

final List<ProcessModel> licenceProcesses = [
  ProcessModel(
    id: 'arms_license_npb',
    categoryId: 'nocs',
    title: 'Arms License (Non Prohibited Bore, Punjab)',
    summary: 'Personal arms license for protection or sport.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original CNIC with Punjab domicile', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Police character certificate', copies: 1),
      DocumentItemModel(id: 'd3', title: 'Proof that you are on the Active Taxpayer List', copies: 1),
    ],
    office: const OfficeInfo(
      department: 'Home Department Punjab and NADRA e Sahulat Center',
      cityAddresses: {},
      timings: 'Apply online, then pay at a NADRA center',
      fallbackNote: 'Apply online through the Punjab arms license portal, then pay the fee at a NADRA center.',
    ),
    fee: const FeeInfo(
      tiers: [
        FeeTier('Punjab government fee', 'Rs. 50,000'),
        FeeTier('NADRA processing fee', 'About Rs. 3,000'),
      ],
      notes: 'The fee was raised from Rs. 20,000 to Rs. 50,000 under the Punjab Arms Rules 2023. Active taxpayers who paid enough tax may get a 50 percent discount on the government fee.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Apply online on the Punjab Home Department portal.',
        'Clear the eligibility check and background verification.',
        'Pay the fee at NADRA when you get the demand notice.',
      ],
      receiptNote: 'You may buy a weapon only after the license is approved.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Depends on verification',
      followUp: 'The license is issued as a chip based smart card by NADRA.',
    ),
    source: SourceInfo(
      sourceName: 'Dawn: Punjab opens online applications for arms licences',
      url: 'https://www.dawn.com/news/1786219',
      lastVerified: DateTime(2023, 11, 4),
    ),
  ),
  ProcessModel(
    id: 'construction_noc',
    categoryId: 'nocs',
    title: 'Construction Approval and NOC',
    summary: 'Get your building plan approved before you start building.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Ownership documents or registry', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Approved building plan or map', copies: 2),
    ],
    office: const OfficeInfo(
      department: 'Development Authority (for Lahore, LDA)',
      cityAddresses: {
        'Lahore': 'Lahore Development Authority, LDA Plaza, Egerton Road, Lahore',
      },
      timings: 'Mon to Fri, 9am to 3pm',
    ),
    fee: const FeeInfo.varies(
      notes: 'The scrutiny fee depends on plot size and covered area. Confirm the current rate with your development authority.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Submit ownership papers and the building plan for review.',
        'Pay the scrutiny fee.',
        'The authority schedules a site inspection.',
      ],
      receiptNote: 'Keep the file number to track your case.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Depends on the authority',
      followUp: 'Start construction only after approval, and follow the approved plan.',
    ),
    source: SourceInfo(
      sourceName: 'Lahore Development Authority',
      url: 'https://lda.gop.pk',
      lastVerified: DateTime(2026, 8, 10),
    ),
  ),
];
