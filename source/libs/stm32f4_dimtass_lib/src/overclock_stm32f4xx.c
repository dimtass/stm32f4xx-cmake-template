/**
 * overclock_stm32f303.c
 * Copyright 2018 Dimitris Tassopoulos
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * Usage:
 * // In your main.c file add this:
 * extern uint32_t overclock_stm32f303(void);
 * // And then in your main function:
 * SystemCoreClock = overclock_stm32f303();
 * 
 */

#include "stm32f4xx.h"

struct tp_ov_clocks {
	uint32_t pll_m;
	uint32_t pll_n;
	uint32_t pll_p;
};

/**
 * @brief  Overclock to 128MHz
 */
uint32_t overclock_stm32f4xx(void)
{
	/* RCC system reset(for debug purpose) */
	RCC_DeInit();

	/* Enable HSE */
	RCC_HSEConfig(RCC_HSE_ON);

	/* Wait till HSE is ready */
	ErrorStatus HSEStartUpStatus = RCC_WaitForHSEStartUp();

	if(HSEStartUpStatus == SUCCESS)
	{
		/* Enable Prefetch Buffer and set Flash Latency */
    	FLASH->ACR = FLASH_ACR_PRFTEN | FLASH_ACR_ICEN |FLASH_ACR_DCEN |FLASH_ACR_LATENCY_5WS;
	
		/* HCLK = SYSCLK / 1 */
		RCC->CFGR |= (uint32_t)RCC_CFGR_HPRE_DIV1;
		
		/* PCLK2 = HCLK / 1 */
		RCC->CFGR |= (uint32_t)RCC_CFGR_PPRE2_DIV2; // RCC_CFGR_PPRE2_DIV2
		
		/* PCLK1 = HCLK / 2 */
		RCC->CFGR |= (uint32_t)RCC_CFGR_PPRE1_DIV4;	// RCC_CFGR_PPRE1_DIV4

		// RCC->PLLCFGR = PLL_M | (PLL_N << 6) | (((PLL_P >> 1) -1) << 16) |
		// 			(RCC_PLLCFGR_PLLSRC_HSE) | (PLL_Q << 24);
		RCC->PLLCFGR = 25 | (336 << 6) | (((2 >> 1) -1) << 16) |
				(RCC_PLLCFGR_PLLSRC_HSE) | (4 << 24);  
		
		/* Enable the main PLL */
		RCC->CR |= RCC_CR_PLLON;

		/* Wait till the main PLL is ready */
		while((RCC->CR & RCC_CR_PLLRDY) == 0)
		{
		}
		
		/* Select PLL as system clock source */
		RCC->CFGR &= (uint32_t)((uint32_t)~(RCC_CFGR_SW));
		RCC->CFGR |= (uint32_t)RCC_CFGR_SW_PLL;

		/* Wait till PLL is used as system clock source */
		while ((RCC->CFGR & (uint32_t)RCC_CFGR_SWS) != (uint32_t)RCC_CFGR_SWS_PLL)
		{
		}
	}
    return 168000000;
}