import '../models/document_item_model.dart';
import '../models/process_model.dart';
import '../models/process_step_model.dart';


const OfficeInfo _unionCouncil = OfficeInfo(
  department: 'Union Council Office',
  cityAddresses: {},
  timings: 'Mon to Sat, 9am to 3pm',
);

final SourceInfo _certificateFeeSource = SourceInfo(
  sourceName: 'Punjab notification on certificate fees (Express Tribune report)',
  url: 'https://tribune.com.pk/story/2319285/govt-reduces-fees-for-various-certificates',
  lastVerified: DateTime(2021, 9, 9),
);

final List<ProcessModel> certificateProcesses = [
  ProcessModel(
    id: 'police_character_certificate',
    categoryId: 'certificates',
    title: 'Police Character Certificate',
    summary: 'Proof of a clean record for visa, job or immigration.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original CNIC or B Form, with a photocopy', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Passport, original and copy', copies: 1),
      DocumentItemModel(id: 'd3', title: 'Signed affidavit', copies: 1),
    ],
    office: const OfficeInfo(
      department: 'Punjab Khidmat Markaz (PKM)',
      cityAddresses: {},
      timings: 'Mon to Sat, working hours of the center',
    ),
    fee: const FeeInfo(
      tiers: [FeeTier('PKM counter fee', 'Rs. 500')],
      notes: 'You can apply at any Punjab Khidmat Markaz. Applying through the Punjab Police app adds service charges.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Visit a Punjab Khidmat Markaz with your documents.',
        'Your documents are verified and you pay Rs. 500 at the counter.',
        'The application goes for a police background check.',
      ],
      receiptNote: 'The certificate carries a QR code so it can be verified later.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'About 3 working days',
      followUp: 'The certificate is dispatched to your address.',
    ),
    source: SourceInfo(
      sourceName: 'Punjab Khidmat Markaz',
      url: 'https://pkm.punjab.gov.pk',
      lastVerified: DateTime(2026, 1, 25),
    ),
  ),
  ProcessModel(
    id: 'birth_registration',
    categoryId: 'certificates',
    title: 'Birth Certificate Registration',
    summary: 'Register a birth and get a computerised certificate.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Hospital birth slip', copies: 1),
      DocumentItemModel(id: 'd2', title: 'CNIC of both parents', copies: 2),
    ],
    office: _unionCouncil,
    fee: const FeeInfo(
      tiers: [
        FeeTier('Computerised certificate', 'Rs. 200'),
        FeeTier('Late registration, after 60 days and before 7 years', 'Rs. 200'),
        FeeTier('Late registration, after 7 years', 'Rs. 300'),
      ],
    ),
    submit: const SubmitInfo(
      instructions: [
        'Submit the registration form at your Union Council.',
        'Pay the fee.',
      ],
      receiptNote: 'You need this certificate to get the child B Form from NADRA.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'A few working days',
      followUp: 'Use the certificate to apply for the B Form.',
    ),
    source: _certificateFeeSource,
  ),
  ProcessModel(
    id: 'death_registration',
    categoryId: 'certificates',
    title: 'Death Certificate Registration',
    summary: 'Register a death and get a computerised certificate.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Hospital or medical death report', copies: 1),
      DocumentItemModel(id: 'd2', title: 'CNIC of the deceased and the applicant', copies: 2),
    ],
    office: _unionCouncil,
    fee: const FeeInfo(tiers: [FeeTier('Computerised certificate', 'Rs. 200')]),
    submit: const SubmitInfo(
      instructions: [
        'Submit the application at your Union Council.',
        'Pay the fee.',
      ],
      receiptNote: 'The certificate is needed for inheritance and updating records.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'A few working days',
      followUp: 'Update the NADRA record using this certificate.',
    ),
    source: _certificateFeeSource,
  ),
  ProcessModel(
    id: 'marriage_registration',
    categoryId: 'certificates',
    title: 'Marriage Certificate (Nikah Nama)',
    summary: 'Register a nikah and get a computerised certificate.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Signed Nikah Nama', copies: 1),
      DocumentItemModel(id: 'd2', title: 'CNIC of both spouses', copies: 2),
    ],
    office: _unionCouncil,
    fee: const FeeInfo(tiers: [FeeTier('Computerised certificate', 'Rs. 200')]),
    submit: const SubmitInfo(
      instructions: [
        'Submit the Nikah Nama at your Union Council.',
        'Pay the fee.',
      ],
      receiptNote: 'Needed for visa applications and family registration.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'A few working days',
      followUp: 'Update your FRC at NADRA if required.',
    ),
    source: _certificateFeeSource,
  ),
  ProcessModel(
    id: 'divorce_registration',
    categoryId: 'certificates',
    title: 'Divorce Certificate Registration',
    summary: 'Register a divorce and get a computerised certificate.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Talaq Nama or court order', copies: 1),
      DocumentItemModel(id: 'd2', title: 'CNIC of both parties', copies: 2),
    ],
    office: _unionCouncil,
    fee: const FeeInfo(tiers: [FeeTier('Computerised certificate', 'Rs. 200')]),
    submit: const SubmitInfo(
      instructions: [
        'Submit the Talaq Nama at your Union Council.',
        'Pay the fee.',
      ],
      receiptNote: 'Needed for NADRA and legal records.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'A few working days',
      followUp: 'Update the marital status at NADRA.',
    ),
    source: _certificateFeeSource,
  ),
];
