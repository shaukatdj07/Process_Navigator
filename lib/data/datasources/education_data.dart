import '../models/document_item_model.dart';
import '../models/process_model.dart';
import '../models/process_step_model.dart';

final List<ProcessModel> educationProcesses = [
  ProcessModel(
    id: 'hec_degree_attestation',
    categoryId: 'education',
    title: 'HEC Degree Attestation',
    summary: 'Attest your university degree and transcript online.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Degree and transcript, scanned', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Matric and Intermediate certificates with IBCC attestation', copies: 1),
      DocumentItemModel(id: 'd3', title: 'CNIC, POC or passport', copies: 1),
    ],
    office: const OfficeInfo(
      department: 'HEC Degree Attestation System',
      cityAddresses: {},
      timings: 'Online, available all day',
      fallbackNote: 'The new HEC system is fully online. You do not need to visit an HEC office.',
    ),
    fee: const FeeInfo(
      tiers: [FeeTier('Attestation fee, per document', 'Rs. 3,000')],
      notes: 'This is the fee reported after the new system launched on 11 May 2026. The old Rs. 1,000 per original fee no longer applies. Confirm the amount shown on your application before paying.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Register on the HEC eServices portal and complete your profile.',
        'Upload your documents and select what to attest.',
        'Pay using the 1Link consumer number that is generated.',
      ],
      receiptNote: 'You receive a downloadable e certificate.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Online processing, faster than the old system',
      followUp: 'The next steps for use abroad are MOFA and then the embassy.',
    ),
    source: SourceInfo(
      sourceName: 'HEC Degree Attestation System',
      url: 'https://www.hec.gov.pk/english/services/students/DAS/Pages/Degree-Attestation.aspx',
      lastVerified: DateTime(2026, 8, 10),
    ),
  ),
  ProcessModel(
    id: 'ibcc_attestation',
    categoryId: 'education',
    title: 'IBCC Attestation (Matric and Intermediate)',
    summary: 'Attest school level certificates before HEC or MOFA.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Original Matric and Intermediate certificates', copies: 1),
      DocumentItemModel(id: 'd2', title: 'Board verification', copies: 1),
      DocumentItemModel(id: 'd3', title: 'CNIC copy', copies: 1),
    ],
    office: const OfficeInfo(
      department: 'Inter Board Committee of Chairmen (IBCC)',
      cityAddresses: {},
      timings: 'Office hours of the IBCC',
    ),
    fee: const FeeInfo.varies(
      notes: 'IBCC charges per document and the amount changes. Confirm it on the IBCC website. IBCC does not attest university degrees, HEC does.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Get your certificates verified by your education board first.',
        'Submit the documents to IBCC in person or by courier.',
        'Pay the fee and collect the attested documents.',
      ],
      receiptNote: 'Without board verification IBCC will not process the attestation.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Can take longer in peak seasons',
      followUp: 'HEC needs the IBCC attested certificates before it attests your degree.',
    ),
    source: SourceInfo(
      sourceName: 'HEC degree attestation FAQ',
      url: 'https://www.hec.gov.pk/english/services/students/DAS/Documents/FAQs.pdf',
      lastVerified: DateTime(2026, 9, 1),
    ),
  ),
  ProcessModel(
    id: 'mofa_attestation',
    categoryId: 'education',
    title: 'MOFA Attestation',
    summary: 'Ministry of Foreign Affairs attestation for use abroad.',
    documents: const [
      DocumentItemModel(id: 'd1', title: 'Documents already attested by HEC or IBCC', copies: 1),
      DocumentItemModel(id: 'd2', title: 'CNIC copy', copies: 1),
    ],
    office: const OfficeInfo(
      department: 'Ministry of Foreign Affairs, Consular Services',
      cityAddresses: {},
      timings: 'Office hours of the MOFA attestation counter',
    ),
    fee: const FeeInfo.varies(
      notes: 'MOFA sets its own attestation charges. Confirm the current amount on the MOFA consular services page.',
    ),
    submit: const SubmitInfo(
      instructions: [
        'Get the documents attested by HEC or IBCC first.',
        'Submit them at the MOFA attestation counter.',
        'Pay the fee and collect the attested documents.',
      ],
      receiptNote: 'Madaris certificates need IBCC or HEC attestation before MOFA.',
    ),
    nextStep: const NextStepInfo(
      timeline: 'Depends on the counter',
      followUp: 'Some countries also need embassy legalisation after MOFA.',
    ),
    source: SourceInfo(
      sourceName: 'Ministry of Foreign Affairs consular services',
      url: 'https://www.mofa.gov.pk/tabs/consular-service-attestation-of-documents',
      lastVerified: DateTime(2026, 9, 1),
    ),
  ),
];
