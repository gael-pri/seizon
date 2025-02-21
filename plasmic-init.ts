import * as PlasmicLibrary from "@ScrollAgency/plasmic-library";
import { getComponentProps, type ComponentMeta, mapPropType } from "@ScrollAgency/plasmic-library";
import { initPlasmicLoader } from "@plasmicapp/loader-nextjs";
import {
  SupabaseProvider,
  SupabaseProviderMeta,
  SupabaseUserGlobalContext,
  SupabaseUserGlobalContextMeta,
  SupabaseUppyUploader,
  SupabaseUppyUploaderMeta,
  SupabaseStorageGetSignedUrl,
  SupabaseStorageGetSignedUrlMeta,
} from "plasmic-supabase"

export const PLASMIC = initPlasmicLoader({
  projects: [
    {
      id: process.env.NEXT_PUBLIC_PLASMIC_PROJECT_ID!,
      token: process.env.NEXT_PUBLIC_PLASMIC_PROJECT_TOKEN!,
    },
  ],

  preview: true,
});

// Fonction pour enregistrer un composant dans Plasmic
function registerComponent(componentName: string) {
  const component = PlasmicLibrary.components[componentName];
  const meta = PlasmicLibrary.componentsMeta.find((m) => m.name === componentName) as ComponentMeta;

  if (!component || !meta) {
    console.error(`Impossible d'enregistrer ${componentName}. Métadonnées ou composant manquant.`);
    return;
  }

  const props = getComponentProps(meta);
  PLASMIC.registerComponent(component, {
    name: componentName,
    props,
    section: meta.section || "Scroll components",
  });
}

// Enregistrement des composants dynamiques
Object.keys(PlasmicLibrary.components).forEach(registerComponent);

//Register global context
PLASMIC.registerGlobalContext(SupabaseUserGlobalContext, SupabaseUserGlobalContextMeta)

//Register components
PLASMIC.registerComponent(SupabaseProvider, SupabaseProviderMeta);
PLASMIC.registerComponent(SupabaseUppyUploader, SupabaseUppyUploaderMeta);
PLASMIC.registerComponent(SupabaseStorageGetSignedUrl, SupabaseStorageGetSignedUrlMeta);