# Changelog

## [1.2.0](https://github.com/MPUSP/snakemake-simple-mapping/compare/v1.1.1...v1.2.0) (2025-08-12)


### Features

* added variant effect prediction module ([9e9d940](https://github.com/MPUSP/snakemake-simple-mapping/commit/9e9d940e2e6af376b58802ce8c47f7c53d0b7bdb))
* added VEP for variant prediction ([354548a](https://github.com/MPUSP/snakemake-simple-mapping/commit/354548aab52363677e957001245d177a9f00cae9))


### Bug Fixes

* added missing documentation ([b2156eb](https://github.com/MPUSP/snakemake-simple-mapping/commit/b2156eb40057aa11e37a0aa8abc09a5f830fcbd2))
* added script to reformat GFF for VEP ([6d19814](https://github.com/MPUSP/snakemake-simple-mapping/commit/6d19814a813ff0d5cc7f05f0de8b69d28bc2f6f9))
* location of vep log file ([9d5d7a8](https://github.com/MPUSP/snakemake-simple-mapping/commit/9d5d7a803ac15a97abf026cab8d1716362174f66))
* make multiqc recognize vep output ([a01343b](https://github.com/MPUSP/snakemake-simple-mapping/commit/a01343b7dc40876012a9d4c45300e1077f1349e5))
* more changes to convert NCBI to ensemble GFF format ([8a9a948](https://github.com/MPUSP/snakemake-simple-mapping/commit/8a9a948004d30e4c7df10f7c654504c6d2c33c87))

## [1.1.1](https://github.com/MPUSP/snakemake-simple-mapping/compare/v1.1.0...v1.1.1) (2025-06-20)


### Bug Fixes

* adjusted resource allocation ([5e7d8a3](https://github.com/MPUSP/snakemake-simple-mapping/commit/5e7d8a3ce1c31c3f2023beb8adb36dd0b6f1b14c))
* adjusted resource definitions ([8667d70](https://github.com/MPUSP/snakemake-simple-mapping/commit/8667d70278cef36e6fc556a772e958fe85817f95))
* bug setting cores dynamically, use static number ([bbe6509](https://github.com/MPUSP/snakemake-simple-mapping/commit/bbe6509361794ba3b4e0bff6e9e323297c647aaf))
* exposed parameters for some tools ([068d30d](https://github.com/MPUSP/snakemake-simple-mapping/commit/068d30d74c7ff6eb62deb5fc169ba7bd49f7a3a8))
* exposed parameters for some tools ([55a0ac4](https://github.com/MPUSP/snakemake-simple-mapping/commit/55a0ac4addcbffb75d260eb5fb1524d0db1c1ba3))

## [1.1.0](https://github.com/MPUSP/snakemake-simple-mapping/compare/v1.0.0...v1.1.0) (2025-06-19)


### Features

* added freebayes as second variant caller ([d4d49b8](https://github.com/MPUSP/snakemake-simple-mapping/commit/d4d49b8a60309e59aa60c49df51f377a7aa594ee))
* various improvements regarding input options, docs ([fc2fa4d](https://github.com/MPUSP/snakemake-simple-mapping/commit/fc2fa4dc2608c840f012b3b8b0db276be450ba1b))


### Bug Fixes

* added dag as workflow overview ([24be9b4](https://github.com/MPUSP/snakemake-simple-mapping/commit/24be9b4ef86425142f5464185a2eb6e4bb5fc80d))
* explicit link to fasta index ([5a7e895](https://github.com/MPUSP/snakemake-simple-mapping/commit/5a7e89537b1cc4e6cd6e65ae1113f09871995ad6))
* removed unnecessary fastp_se rule ([232a784](https://github.com/MPUSP/snakemake-simple-mapping/commit/232a784899a34e3c8127965c387ba9d8d29aa141))
* update dag ([ce4c68c](https://github.com/MPUSP/snakemake-simple-mapping/commit/ce4c68c9fc91d4e6d60ad0464c5de91773d57762))
* works now seamless with paired and single end input ([5844af8](https://github.com/MPUSP/snakemake-simple-mapping/commit/5844af810006f0f5cc5bd847d2aaf8530c33a299))

## 1.0.0 (2025-06-18)


### Features

* added bowtie2 mapper ([17fd091](https://github.com/MPUSP/snakemake-simple-mapping/commit/17fd091a8eae6c54aa87d3f493976783fc59ba3e))
* added bwa-mem2 as mapper ([b2508b2](https://github.com/MPUSP/snakemake-simple-mapping/commit/b2508b2cb566969321e1dd4632ddc365370eee62))
* added deeptools to produce bigwig cov ([04dbd94](https://github.com/MPUSP/snakemake-simple-mapping/commit/04dbd94d48af4a1afe6ecab9c17169e18d78bbe2))
* added license ([a4831f3](https://github.com/MPUSP/snakemake-simple-mapping/commit/a4831f370001ac4708368954906497b00269f28c))
* added module to retrieve mapping stats, exposed params ([421001a](https://github.com/MPUSP/snakemake-simple-mapping/commit/421001aca615a899c5ad653015571cda89ea77ae))
* added schemas for sample sheet and config files ([87385b7](https://github.com/MPUSP/snakemake-simple-mapping/commit/87385b71f9f8d645ce1b9080cfa533913aac1aef))
* added test data set ([2f917ca](https://github.com/MPUSP/snakemake-simple-mapping/commit/2f917ca0681c9e14bac8629e4cc809ee586bc003))
* adding mappers, various improvements ([66756d2](https://github.com/MPUSP/snakemake-simple-mapping/commit/66756d252606005abbe6e312872a786addd51c9c))
* initial commit ([822a07c](https://github.com/MPUSP/snakemake-simple-mapping/commit/822a07c49727e72a91bf903b34fa4604f708695e))


### Bug Fixes

* linting ([2b8d7d0](https://github.com/MPUSP/snakemake-simple-mapping/commit/2b8d7d06bb8b3874935fa902cc8f4ab19d96cee2))
