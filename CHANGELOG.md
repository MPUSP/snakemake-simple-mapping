# Changelog

## [1.4.0](https://github.com/MPUSP/snakemake-simple-mapping/compare/v1.3.0...v1.4.0) (2025-09-17)


### Features

* added minimap2 as another mapper option ([99e95d1](https://github.com/MPUSP/snakemake-simple-mapping/commit/99e95d1be49984cd061e894f996287d30cb2e3d5))
* added new modules for mapping ([82cacb3](https://github.com/MPUSP/snakemake-simple-mapping/commit/82cacb36fc7bf67cbbff7a218d02dcc6fcbbc80c))
* added STAR as a mapper option ([9dd4fa8](https://github.com/MPUSP/snakemake-simple-mapping/commit/9dd4fa8931be24a20e5147a557d73e558f55ef7a))
* fix: added option to choose varaint caller to config ([96f51d7](https://github.com/MPUSP/snakemake-simple-mapping/commit/96f51d7f242a4221ad0d3805723b073b408c3271))


### Bug Fixes

* added missing argument input to get_genome ([532afee](https://github.com/MPUSP/snakemake-simple-mapping/commit/532afeea3b91a37f55b0e0d09f86898881a21caf))
* expose extra args in config ([93d4500](https://github.com/MPUSP/snakemake-simple-mapping/commit/93d4500a26594bd774b3a240f45e3eab64096eac))
* minor changes config settings ([aeeab0e](https://github.com/MPUSP/snakemake-simple-mapping/commit/aeeab0e22f185b785684b61d1051d14e3276fc99))
* prevent report from failing when no variants were found + format ([538c772](https://github.com/MPUSP/snakemake-simple-mapping/commit/538c7723f2a32cf25c7da1b41e607506df9f9813))
* tolerate empty genome input ([8f3d0cf](https://github.com/MPUSP/snakemake-simple-mapping/commit/8f3d0cf9b1b920d870b26e7b60d33aee2fbb9f5a))

## [1.3.0](https://github.com/MPUSP/snakemake-simple-mapping/compare/v1.2.0...v1.3.0) (2025-09-15)


### Features

* added first draft of report for most important variants ([5cf5150](https://github.com/MPUSP/snakemake-simple-mapping/commit/5cf515029d910949d6e7f91caa4477674a0d40bd))
* added genome plots to report ([c4acfb1](https://github.com/MPUSP/snakemake-simple-mapping/commit/c4acfb164ca10cc6f50fd83559993bf2398f8b72))
* added rule to collect consensus variants ([f883811](https://github.com/MPUSP/snakemake-simple-mapping/commit/f883811997a54a3cfdcb42c2db98a71b6ca787b8))
* added SnpEff part 1 ([52b4f1d](https://github.com/MPUSP/snakemake-simple-mapping/commit/52b4f1dc7565547ecb50363a51883b62c5cb85cd))
* added SnpEff part 2 ([59c2e69](https://github.com/MPUSP/snakemake-simple-mapping/commit/59c2e6973e5cf6795173e95c2191926b6ae8611b))
* more detailed plots for report ([9cdc49a](https://github.com/MPUSP/snakemake-simple-mapping/commit/9cdc49aba3422c258b5780cf5e4d73e8fae8994d))
* various improvements to variant effect prediction + viz ([103ada1](https://github.com/MPUSP/snakemake-simple-mapping/commit/103ada16e44fed984e793e460a7004b31f90b81a))


### Bug Fixes

* corrected urls to json schema ([d9456d9](https://github.com/MPUSP/snakemake-simple-mapping/commit/d9456d994b11fc2ea08d3baa303167cb05ef6d8f))
* minor formatting ([338d9ee](https://github.com/MPUSP/snakemake-simple-mapping/commit/338d9eecfdd2be5da16015800d88550699718fe6))

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
