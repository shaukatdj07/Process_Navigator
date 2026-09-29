import '../models/document_item_model.dart';
import '../models/process_model.dart';
import '../models/process_step_model.dart';

const OfficeInfo _passportOffice = OfficeInfo(
  department: 'Regional Passport Office',
  cityAddresses: {
    'Lahore': 'Regional Passport Office, Shadman Branch, 8A Shahrah e Tijarat, Lahore',
  },
  timings: 'Mon to Thu, 9am to 2pm. Friday, 9am to 12:30pm',
);

final SourceInfo _dgipSource = SourceInfo(
  sourceName: 'Directorate General of Immigration and Passports (official FAQ)',
  url: 'https://dgip.gov.pk/faq/faq.php',
  lastVerified: DateTime(2026, 7, 22),
);

const SubmitInfo _passportSubmit = SubmitInfo(
  instructions: [
    'Generate a 17 digit PSID on the Passport Fee Asaan app or the DGIP e payment portal.',
    'Pay the fee by 1Link bank, JazzCash, Easypaisa or at a bank branch.',
    'Visit your passport office, give your biometrics and get a token number.',
  ],
  receiptNote: 'Keep the tracking token. You can also track by SMS to 9988.',
);

final List<ProcessModel> travelProcesses = [
  ProcessModel(
    id: 'new_passport_mrp5',
    categoryId: 'travel',
    title: 'New Passport (5 year, 36 pages)',
    summary: 'Apply for a machine readable passport for the first time.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original CNIC', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Original CNIC of both parents', copies: 1),
      DocumentItemModel(id: 'd3', title: 'Spouse CNIC, if married', copies: 1),
    ],
    office: _passportOffice,
    fee: const FeeInfo(
      tiers: [
        FeeTier('Normal (21 working days)', 'Rs. 4,500'),
        FeeTier('Urgent (5 working days)', 'Rs. 7,500'),
      ],
    ),
    submit: _passportSubmit,
    nextStep: const NextStepInfo(
      timeline: 'Normal 21 working days, Urgent 5 working days',
      followUp: 'Collect the passport from the same office or get it by courier for an extra charge.',
    ),
    source: _dgipSource,
  ),
  ProcessModel(
    id: 'passport_renewal_mrp5',
    categoryId: 'travel',
    title: 'Passport Renewal (5 year, 36 pages)',
    summary: 'Renew an expiring or expired passport.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Old passport', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Original CNIC', copies: 1),
    ],
    office: _passportOffice,
    fee: const FeeInfo(
      tiers: [
        FeeTier('Normal (21 working days)', 'Rs. 4,500'),
        FeeTier('Urgent (5 working days)', 'Rs. 7,500'),
      ],
    ),
    submit: _passportSubmit,
    nextStep: const NextStepInfo(
      timeline: 'Normal 21 working days, Urgent 5 working days',
      followUp: 'Collect the new passport from the same office.',
    ),
    source: _dgipSource,
  ),
  ProcessModel(
    id: 'passport_mrp10',
    categoryId: 'travel',
    title: 'Passport (10 year, 36 pages)',
    summary: 'A longer validity machine readable passport for adults.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original CNIC', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Old passport, if renewing', copies: 1),
    ],
    office: _passportOffice,
    fee: const FeeInfo(
      tiers: [
        FeeTier('Normal', 'Rs. 6,700'),
        FeeTier('Urgent', 'Rs. 11,200'),
      ],
      notes: 'Children under 15 can only get a passport valid for a maximum of 5 years.',
    ),
    submit: _passportSubmit,
    nextStep: const NextStepInfo(
      timeline: 'Normal 21 working days, Urgent 5 working days',
      followUp: 'Collect the passport from the same office.',
    ),
    source: SourceInfo(
      sourceName: 'Pakistan Info Hub passport fee guide',
      url: 'https://www.pakistaninfohub.com/passport',
      lastVerified: DateTime(2026, 9, 1),
    ),
  ),
  ProcessModel(
    id: 'epassport_5yr',
    categoryId: 'travel',
    title: 'e Passport (5 year)',
    summary: 'Chip based passport with 36 or 72 pages.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original CNIC', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Old passport, if renewing', copies: 1),
    ],
    office: _passportOffice,
    fee: const FeeInfo(
      tiers: [
        FeeTier('36 pages, Normal', 'Rs. 9,000'),
        FeeTier('72 pages, Normal', 'Rs. 16,500'),
      ],
      notes: 'Urgent rates are higher. Confirm the exact urgent fee on the DGIP fee chart before paying.',
    ),
    submit: _passportSubmit,
    nextStep: const NextStepInfo(
      timeline: 'Depends on the processing category you choose',
      followUp: 'Collect from the passport office. e Passports are available at all DGIP field offices.',
    ),
    source: SourceInfo(
      sourceName: 'e Passport fee chart (DGIP rates)',
      url: 'https://epassport.pk/e-passport-fee-in-pakistan/',
      lastVerified: DateTime(2026, 6, 1),
    ),
  ),
  ProcessModel(
    id: 'epassport_10yr',
    categoryId: 'travel',
    title: 'e Passport (10 year)',
    summary: 'Ten year chip based passport with 36 or 72 pages.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original CNIC', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Old passport, if renewing', copies: 1),
    ],
    office: _passportOffice,
    fee: const FeeInfo(
      tiers: [
        FeeTier('36 pages, Normal', 'Rs. 13,500'),
        FeeTier('72 pages, Normal', 'Rs. 24,750'),
        FeeTier('72 pages, Urgent', 'Rs. 40,500'),
      ],
    ),
    submit: _passportSubmit,
    nextStep: const NextStepInfo(
      timeline: 'Depends on the processing category you choose',
      followUp: 'Collect from the passport office.',
    ),
    source: SourceInfo(
      sourceName: 'e Passport fee chart (DGIP rates)',
      url: 'https://epassport.pk/e-passport-fee-in-pakistan/',
      lastVerified: DateTime(2026, 6, 1),
    ),
  ),
  ProcessModel(
    id: 'lost_passport',
    categoryId: 'travel',
    title: 'Lost Passport Replacement',
    summary: 'Replace a lost or stolen passport.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Police FIR or computerised loss report', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Original CNIC', copies: 1),
    ],
    office: _passportOffice,
    fee: const FeeInfo(
      tiers: [
        FeeTier('First loss (double the normal fee)', 'Rs. 9,000'),
        FeeTier('Second loss (four times the normal fee)', 'Rs. 18,000'),
      ],
      notes: 'Amounts are worked out from the 5 year, 36 page normal fee of Rs. 4,500. A third loss needs clearance from DGIP headquarters in Islamabad.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Report the loss at the nearest police station and get the loss report.',
        'Pay the replacement fee using a PSID.',
        'Visit the passport office with the report and your CNIC.',
      ],
      receiptNote: 'Keep the police report and the fee receipt together.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Usually longer than a normal application',
      followUp: 'You will be told the delivery date at the counter.',
    ),
    source: SourceInfo(
      sourceName: 'Pakistan Info Hub passport services guide',
      url: 'https://www.pakistaninfohub.com/passport',
      lastVerified: DateTime(2026, 9, 1),
    ),
  ),
  ProcessModel(
    id: 'fast_track_passport',
    categoryId: 'travel',
    title: 'Fast Track Passport (2 working days)',
    summary: 'Get a regular passport in two days at an Executive Passport Office.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original CNIC', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Old passport, if renewing', copies: 1),
    ],
    office: const OfficeInfo(
      department: 'Executive Passport Office',
      cityAddresses: {
        'Lahore': 'Executive Passport Office, Sector 10, DHA Phase 3, Lahore',
      },
      timings: 'Mon to Thu, 9am to 2pm. Friday, 9am to 12:30pm',
    ),
    fee: const FeeInfo(
      tiers: [FeeTier('36 page MRP, Fast Track', 'Rs. 12,500')],
      notes: 'Fast Track is offered on the regular machine readable passport. Check with the office if it is available for the e Passport.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Executive Passport Offices are in Islamabad, Lahore, Karachi, Rawalpindi and Peshawar.',
        'Pay the Fast Track fee with a PSID.',
        'Visit the office for your biometrics.',
      ],
      receiptNote: 'Keep the tracking token safe.',
    ),
    nextStep: const NextStepInfo(
      timeline: '2 working days',
      followUp: 'Collect the printed passport from the same Executive office.',
    ),
    source: SourceInfo(
      sourceName: 'DGIP Executive Passport Offices and Fast Track',
      url: 'https://dgip.gov.pk/downloads/EPO-List.pdf',
      lastVerified: DateTime(2026, 9, 1),
    ),
  ),
];
