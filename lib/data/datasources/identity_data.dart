import '../models/document_item_model.dart';
import '../models/process_model.dart';
import '../models/process_step_model.dart';

const OfficeInfo _nadraOffice = OfficeInfo(
  department: 'NADRA Registration Center',
  cityAddresses: {
    'Lahore': 'NADRA Mega Center, Johar Town, Lahore',
  },
  timings: 'Mega Centers are open 24/7. Regular centers: Mon to Sat, 9am to 4pm',
);

final SourceInfo _nadraSource = SourceInfo(
  sourceName: 'NADRA fee schedule (update of 7 April 2026)',
  url: 'https://www.nadra.gov.pk',
  lastVerified: DateTime(2026, 4, 7),
);

const List<FeeTier> _smartCardTiers = [
  FeeTier('Normal (31 days)', 'Rs. 750'),
  FeeTier('Urgent (23 days)', 'Rs. 1,500'),
  FeeTier('Executive (9 days)', 'Rs. 2,500'),
];

final List<ProcessModel> identityProcesses = [
  ProcessModel(
    id: 'new_smart_nic',
    categoryId: 'identity',
    title: 'New Smart National Identity Card',
    summary: 'Get your first CNIC when you turn 18.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original CNIC of father or mother', copies: 1),
      DocumentItemModel(id: 'd2', title: 'B Form (Child Registration Certificate)', copies: 1),
      DocumentItemModel(id: 'd3', title: 'Matric certificate or school leaving proof', copies: 1),
    ],
    office: _nadraOffice,
    fee: const FeeInfo(
      tiers: _smartCardTiers,
      notes: 'A first CNIC on the basic (non smart) card is free on Normal processing. The smart chip card is charged as shown.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Take a token at the NADRA center and submit the application form.',
        'Give your fingerprints and photo at the counter.',
        'Pay the fee for the category you chose and keep the receipt.',
      ],
      receiptNote: 'Keep the receipt and tracking ID. You need them to track the card.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Normal 31 days, Urgent 23 days, Executive 9 days',
      followUp: 'The card is delivered to your address by courier.',
    ),
    source: _nadraSource,
  ),
  ProcessModel(
    id: 'smart_nic_renewal',
    categoryId: 'identity',
    title: 'CNIC Renewal',
    summary: 'Renew an expiring or expired CNIC.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Old CNIC (original)', copies: 1),
    ],
    office: _nadraOffice,
    fee: const FeeInfo(
      tiers: [
        FeeTier('Smart NIC, Normal (31 days)', 'Rs. 750'),
        FeeTier('Smart NIC, Urgent (23 days)', 'Rs. 1,500'),
        FeeTier('Smart NIC, Executive (9 days)', 'Rs. 2,500'),
        FeeTier('Basic CNIC, Normal', 'Rs. 400'),
        FeeTier('Basic CNIC, Urgent', 'Rs. 1,150'),
        FeeTier('Basic CNIC, Executive', 'Rs. 2,150'),
      ],
    ),
    submit: const SubmitInfo(
      instructions: [
        'Fill the renewal form and submit it with your old CNIC.',
        'Your biometrics are verified again at the counter.',
        'Pay the fee and collect the receipt.',
      ],
      receiptNote: 'The tracking slip lets you check card status online.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Between 9 and 31 days depending on the category',
      followUp: 'The new card arrives by courier.',
    ),
    source: _nadraSource,
  ),
  ProcessModel(
    id: 'smart_nic_modification',
    categoryId: 'identity',
    title: 'CNIC Modification',
    summary: 'Correct name, address or other details on your CNIC.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Old CNIC (original)', copies: 1),
      DocumentItemModel(
        id: 'd2',
        title: 'Proof for the change, such as marriage certificate or education certificate',
        copies: 1,
        attestationRequired: true,
      ),
    ],
    office: _nadraOffice,
    fee: const FeeInfo(
      tiers: _smartCardTiers,
      notes: 'The basic (non smart) card costs Rs. 400, Rs. 1,150 and Rs. 2,150 for the same three categories.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Submit the modification form and your proof documents at the counter.',
        'The verification officer checks your documents.',
        'Pay the fee and keep the receipt.',
      ],
      receiptNote: 'Keep the receipt, verification can take extra time.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Between 9 and 31 days depending on the category',
      followUp: 'The updated card is delivered by courier.',
    ),
    source: _nadraSource,
  ),
  ProcessModel(
    id: 'duplicate_smart_nic',
    categoryId: 'identity',
    title: 'Duplicate CNIC (Lost or Damaged)',
    summary: 'Get a replacement for a lost or damaged CNIC.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'FIR or police loss report, if the card is lost', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Damaged card, if it is damaged', copies: 1),
    ],
    office: _nadraOffice,
    fee: const FeeInfo(
      tiers: _smartCardTiers,
      notes: 'Charged in the same tier as a modification.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'If the card is lost, first report it and get a copy of the loss report.',
        'Apply for a duplicate at the NADRA center.',
        'Pay the fee and keep the receipt.',
      ],
      receiptNote: 'Keep the tracking number safe.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Between 9 and 31 days depending on the category',
      followUp: 'The new card is delivered by courier.',
    ),
    source: _nadraSource,
  ),
  ProcessModel(
    id: 'child_registration_certificate',
    categoryId: 'identity',
    title: 'Child Registration Certificate (B Form)',
    summary: 'The first official identity document of a child.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original CNIC of both parents', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Birth certificate from hospital or Union Council', copies: 1),
    ],
    office: _nadraOffice,
    fee: const FeeInfo(
      tiers: [
        FeeTier('Normal (7 days)', 'Rs. 50'),
        FeeTier('Executive (1 day)', 'Rs. 500'),
      ],
    ),
    submit: const SubmitInfo(
      instructions: [
        'Visit the NADRA center with the parents.',
        'Fill the form and attach the birth certificate.',
        'Pay the fee and keep the receipt.',
      ],
      receiptNote: 'Keep the receipt until the B Form arrives.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Normal 7 days, Executive 1 day',
      followUp: 'The B Form is delivered by courier.',
    ),
    source: _nadraSource,
  ),
  ProcessModel(
    id: 'family_registration_certificate',
    categoryId: 'identity',
    title: 'Family Registration Certificate (FRC)',
    summary: 'The official list of all registered members of a family.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original CNIC of the head of family', copies: 1),
    ],
    office: _nadraOffice,
    fee: const FeeInfo(
      tiers: [FeeTier('Executive only (24 hours)', 'Rs. 1,000')],
      notes: 'FRC is issued only in the Executive category.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Apply for the FRC at a NADRA center.',
        'Pay the fee and keep the receipt.',
      ],
      receiptNote: 'Keep the receipt safe.',
    ),
    nextStep: const NextStepInfo(
      timeline: '24 hours',
      followUp: 'The FRC is printed and handed over after processing.',
    ),
    source: _nadraSource,
  ),
  ProcessModel(
    id: 'nicop',
    categoryId: 'identity',
    title: 'NICOP (Overseas Pakistani ID Card)',
    summary: 'Identity card for Pakistanis living abroad.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Valid passport', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Proof of residence abroad, such as visa or residence permit', copies: 1),
    ],
    office: const OfficeInfo(
      department: 'NADRA Executive Center or Pakistan Mission abroad',
      cityAddresses: {
        'Lahore': 'NADRA Mega Center, Johar Town, Lahore',
      },
      timings: 'Mega Centers are open 24/7',
    ),
    fee: const FeeInfo(
      tiers: [FeeTier('Smart NICOP, by zone and priority', 'USD 20 to USD 75')],
      notes: 'The exact amount depends on your zone and the processing priority you choose.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Apply at a NADRA Executive Center or a Pakistan mission abroad.',
        'Your biometrics and documents are verified.',
        'Pay the fee in US dollars and keep the receipt.',
      ],
      receiptNote: 'Keep the receipt and tracking number.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Depends on zone and category',
      followUp: 'The card is sent by courier or mail.',
    ),
    source: SourceInfo(
      sourceName: 'NADRA fee structure (verified against NADRA schedule)',
      url: 'https://identityservices.pk/nadra-fee-structure/',
      lastVerified: DateTime(2026, 8, 4),
    ),
  ),
];
