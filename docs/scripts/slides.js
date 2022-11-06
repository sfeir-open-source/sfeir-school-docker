import { SfeirThemeInitializer } from '../web_modules/sfeir-school-theme/sfeir-school-theme.mjs';

// One method per module
function schoolSlides() {
  return [
    '00-school/00-TITLE.md',
    '00-school/00-speaker-thibauld.md',
    '00-school/00-participant.md',
    '00-school/00-prerequisites.md',
    '00-school/00-plan.md'
  ];
}


function introductionSlides() {
  return [
    '10-introduction/00-TITLE.md',
    '10-introduction/01-meaning.md',
    '10-introduction/02-container-runtime.md',
    '10-introduction/03-docker-on-your-machine.md'
  ];
}

function basicsSlides() {
  return [
    '20-basics/00-TITLE.md',
    '20-basics/01-images_and_container-empty.md',
    '20-basics/01-images_and_container.md',
    '20-basics/02-registry.md',
    '20-basics/03-CLI.md',
    '20-basics/99-TITLE.md',
    '20-basics/99-exercices.md'
   ];
}

function imagesAndContainersSlides() {
  return [
    '30-images-containers/00-TITLE.md',
    '30-images-containers/01-VM-vs-containers.md',
    '30-images-containers/02-VM-and-containers.md',
    '30-images-containers/03-layers.md',
    '30-images-containers/99-TITLE.md',
    '30-images-containers/99-exercices.md'
   ];
}

function networkSlides() {
  return [
    '40-network/00-TITLE.md',
    '40-network/01-network-basics.md',
    '40-network/99-TITLE.md',
    '40-network/99-exercices.md'
   ];
}

function volumesSlides() {
  return [
    '50-volumes/00-TITLE.md',
    '50-volumes/01-volumes.md',
    '50-volumes/99-TITLE.md',
    '50-volumes/99-exercices.md'
   ];
}

function dockerfileSlides() {
  return [
    '60-dockerfile/00-TITLE.md',
    '60-dockerfile/01-dockerfile.md',
    '60-dockerfile/02-instruction.md',
    '60-dockerfile/99-TITLE.md',
    '60-dockerfile/99-exercices.md'
   ];
}

function dockerComposeSlides() {
  return [
    '70-docker-compose/00-TITLE.md',
    '70-docker-compose/01-docker-compose-basics.md',
    '70-docker-compose/02-docker-compose-example.md',
    '70-docker-compose/03-docker-compose-content.md',
    '70-docker-compose/99-TITLE.md',
    '70-docker-compose/99-exercices.md'
   ];
}

function productionsUsagesSlides() {
  return [
    '80-production-usages/00-TITLE.md',
    '80-production-usages/01-best-practices.md',
    '80-production-usages/02-TITLE.md',
    '80-production-usages/02-kubernetes.md',
   ];
}

function conclusionSlides() {
  return [
    '90-conclusion/00-TITLE.md'
  ];
}

function formation() {
  return [
    //
    ...schoolSlides(), //
    ...introductionSlides(), //
    ...basicsSlides(), //
    ...imagesAndContainersSlides(), //
    ...networkSlides(), //
    ...volumesSlides(), //
    ...dockerfileSlides(), //
    ...dockerComposeSlides(), //
    ...productionsUsagesSlides(), //
    ...conclusionSlides() //
  ].map(slidePath => {
    return { path: slidePath };
  });
}

SfeirThemeInitializer.init(formation);
